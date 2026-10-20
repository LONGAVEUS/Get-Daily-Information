import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin Akses Lokasi di Tolak Oleh Pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Izin Akses Lokasi di Tolak Secara Permanen, Aplikasi Tidak Dapat Mengakses Lokasi.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getCityName() async {
    try {
      Position position = await getCurrentPosition();

      final url = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'format': 'json',
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'zoom': '18',
          'addressdetails': '1',
        },
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'NetraApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          final address = data['address'];

          String jalan = address['road'] ?? address['pedestrian'] ?? " ";

          String bangunan = address['building'] ?? address['amenity'] ?? " ";

          String kota = address['city'] ?? " ";

          String detailLokasi = "Anda saat ini sedang berada $jalan";

          if (bangunan.isNotEmpty) {
            detailLokasi += ", Dekat atau berada di dalam area $bangunan";
          }

          detailLokasi += ", Kota $kota.";

          return detailLokasi;
        } else {
          return 'Lokasi tidak ditemukan';
        }
      } else {
        return 'Gagal terhubung ke server peta, harap coba lagi setelah beberapa menit';
      }
    } catch (e) {
      return 'Gagal mengambil lokasi, Pastikan GPS dan Internet anda aktif';
    }
  }
}
