import 'time_service.dart';

class CommandService {
  final TimeService _timeService = TimeService();

  String generateResponse(String userInput) {
    String text = userInput.toLowerCase();
  
    if (text.contains("jam") || text.contains("waktu") || text.contains("pukul")) {
        return _timeService.getCurrentTime();
      
    } 
    else if (text.contains("tanggal") || text.contains("hari") || text.contains("bulan") || text.contains("tahun")) {
        return _timeService.getCurrentDate();
    } 
    else if (text.isEmpty) {
        return "Maaf, saya tidak mengerti pertanyaan Anda.";
    }
    else {
        return "Maaf, saya belum mengerti perintah: $text. Coba tanyakan Jam atau Hari.";
    }
  }
}