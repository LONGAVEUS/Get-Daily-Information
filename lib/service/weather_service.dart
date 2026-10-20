import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_service.dart';

class WeatherService {
  final LocationService _locationService = LocationService();
    
  Future<String> getWeatherInfo() async {
    try {
      var position = await _locationService.getCurrentPosition();
      
      final url = Uri.parse (
        'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currentWeather = (data['current_weather']);

        double temperature = currentWeather['temperature'];
        int weatherCode = currentWeather['weathercode'];

        String weather = _translateWeatherCode(weatherCode);

        return "Cuaca saat ini adalah $weather dengan Suhu ${temperature.toStringAsFixed(1)}";
      } else {
        return 'Gagal Mengambil Data Cuaca';
      } 
    } catch (e) {

      return 'Terjadi kesalahan saat mengambil cuaca. Pastikan GPS dan internet Aktif.';
    }
  }

  String _translateWeatherCode(int code) {
    switch (code) {
      case 0: return "Cerah";
      case 1: return "Cerah Berawan";
      case 2: return "Berawan sebagian";
      case 3: return "Mendung";
      case 45: return "Berkabut";
      case 51: case 53: case 55: return "Gerimis";
      case 56: case 57: return "Hujan Beku";
      case 61: return "Hujan Ringan";
      case 63: return "Hujan";
      case 65: return "Hujan Lebat";
      case 66: case 67: return "Hujan beku";
      case 71: return "Salju ringan";
      case 73: return "Salju";
      case 75: return "Salju lebat";
      case 77: return "Butiran salju";
      case 80: return "Hujan sesaat";
      case 81: case 82: return "Hujan deras";
      case 85: case 86: return "Hujan salju";
      case 95: case 96: case 97: case 99: return "Badai petir";
      default: return "Cuaca tidak diketahui";
    }
  }
}