import 'time_service.dart';
import 'location_service.dart';
import 'weather_service.dart';

class CommandService {
  final TimeService _timeService = TimeService();
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  Future<String> generateResponse(String userInput) async {
    String text = userInput.toLowerCase();

    if (text.contains("jam") || text.contains("waktu") || text.contains("pukul") || text.contains("jam berapa sekarang")
      || text.contains("pukul berapa sekarang")) {
        return _timeService.getCurrentTime();
    }
    else if (text.contains("tanggal") || text.contains("hari") || text.contains("bulan") || text.contains("tahun")
        || text.contains("tanggal berapa sekarang") || text.contains("hari apa ini") || text.contains("bulan apa sekarang")
        || text.contains("tahun berapa sekarang")) {
        return _timeService.getCurrentDate();
    } 
    else if (text.contains("lokasi") || text.contains("dimana") || text.contains('di mana') || text.contains('posisi')
        || text.contains('lokasi saya saat ini') || text.contains('posisi saya saat ini') || text.contains('di mana saya saat ini')) {
      String cityName = await _locationService.getCityName();
      return "$cityName.";
    }
    else if (text.contains("cuaca") || text.contains("hujan") || text.contains("cerah") || text.contains("berawan") || text.contains("berkabut")
        || text.contains("salju") || text.contains("cuaca hari ini") || text.contains("hujankah hari ini")
        || text.contains("panaskah hari ini") || text.contains("kondisi cuaca saat ini")) {

      String weatherService = await _weatherService.getWeatherInfo();
      return weatherService;
    }
  
    else if (text.contains("perintah") || text.contains("bantuan") || text.contains("apa saja") 
        || text.contains("informasi apa") || text.contains("bisa apa") || text.contains("tanya apa")) {
      return "Anda bisa menanyakan informasi umum seperti hari, tanggal, jam, cuaca, dan lokasi Anda saat ini.";
    }
    
    else if (text.trim().isEmpty) {
      return "Suara tidak terdengar, silakan ketuk layar lagi.";
    } 

    else {
      return 'Maaf, saya tidak mengerti perintah "$text".';
    }
  }
}