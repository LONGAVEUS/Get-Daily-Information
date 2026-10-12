import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isListening = false;
  bool isResultAvailable = false;
  bool hasSpoken = false;
  Timer? _silenceTimer;

  String _teksHasilJawaban = ""; 

  final Color neonYellow = const Color(0xFFE6FF00);
  final Color textWhite = Colors.white;
  final Color backgroundBlack = Colors.black;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _tts.setLanguage("id-ID");
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await Future.delayed(const Duration(milliseconds: 1000));
    _tts.speak("Halo. Informasi apa yang ingin anda ketahui?");
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _tts.stop();
    super.dispose();
  }

  String _generateResponse(String userInput) {
    String text = userInput.toLowerCase();
    DateTime now = DateTime.now();

    if (text.contains("jam") || text.contains("waktu") || text.contains("pukul")) {
      return "Saat ini menunjukkan pukul ${now.hour} lewat ${now.minute} menit.";
    } 
    
    else if (text.contains("tanggal") || text.contains("hari")) {
      List<String> namaHari = ["", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
      List<String> namaBulan = ["", "Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
      
      String hariIni = namaHari[now.weekday];
      String bulanIni = namaBulan[now.month];
      
      return "Hari ini adalah hari $hariIni, tanggal ${now.day} $bulanIni ${now.year}.";
    } 
    else {
      return "Maaf, saya belum mengerti perintah Anda.";
    }
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && isListening) {
        if (!hasSpoken) {
          setState(() { isListening = false; });
          HapticFeedback.lightImpact();
        } else {
          _processResult();
        }
      }
    });
  }

  void _onWordDetectedBySTT() {
    setState(() { hasSpoken = true; });
    _startSilenceTimer(); 
  }

  void _processResult() {

    String kalimatDummy = "halo jam berapa sekarang";
    String jawaban = _generateResponse(kalimatDummy);

    setState(() {
      isListening = false;
      isResultAvailable = true;
      _teksHasilJawaban = jawaban; // Gunakan teks dinamis
    });
    HapticFeedback.heavyImpact();
    _tts.speak(jawaban);
  }

  void _handleScreenTap() {
    HapticFeedback.mediumImpact();

    if (isResultAvailable) {
      setState(() { isResultAvailable = false; });
      _tts.stop();
    } else if (isListening) {
      setState(() { isListening = false; });
      _silenceTimer?.cancel();
    } else {
      setState(() {
        isListening = true;
        hasSpoken = false;
      });
      _startSilenceTimer();

      Future.delayed(const Duration(seconds: 1), () {
        _onWordDetectedBySTT();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundBlack,
          border: Border.all(color: neonYellow, width: 4.0),
          borderRadius: BorderRadius.circular(35),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleScreenTap,
            child: Center(
              child: isResultAvailable
                  ? _buildResultUI()
                  : (isListening ? _buildListeningUI() : _buildInitialUI()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tekan Layar', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: textWhite)),
        const SizedBox(height: 5),
        Text('Tekan layar dimana pun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textWhite)),
        const SizedBox(height: 30),
        _buildMicButton(),
        const SizedBox(height: 20),
        Text('Halo Pengguna!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: textWhite)),
      ],
    );
  }

  Widget _buildListeningUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitThreeBounce(color: neonYellow, size: 40.0),
        const SizedBox(height: 30),
        Text('Mendengarkan...', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textWhite)),
      ],
    );
  }

  Widget _buildResultUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMicButton(),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '"$_teksHasilJawaban"', // Tampilkan dari variabel
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textWhite, height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMicButton() {
    return ElevatedButton(
      onPressed: _handleScreenTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundBlack, shape: const CircleBorder(),
        padding: const EdgeInsets.all(30), side: BorderSide(color: neonYellow, width: 3),
      ),
      child: Icon(Icons.graphic_eq, color: neonYellow, size: 32),
    );
  }
}