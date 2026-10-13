import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; 
import 'service/command_service.dart';

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

  String _recognizedWords = ""; 
  String _teksHasilJawaban = ""; 
  final stt.SpeechToText _speech = stt.SpeechToText(); 

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
    
    await _speech.initialize();

    await Future.delayed(const Duration(milliseconds: 1000));
    _tts.speak("Halo. Informasi apa yang ingin anda ketahui?");
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _tts.stop();
    _speech.stop(); 
    super.dispose();
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && isListening) {
        if (!hasSpoken) {
          setState(() { isListening = false; });
          _speech.stop(); 
          HapticFeedback.lightImpact();
        } else {
          _processResult();
        }
      }
    });
  }

  
  void _startListeningReal() async {
    setState(() {
      isListening = true;
      hasSpoken = false;
      _recognizedWords = "";
    });

    _startSilenceTimer();

    await _speech.listen(
      localeId: 'id_ID',
      onResult: (result) {
        setState(() {
          hasSpoken = true;
          _recognizedWords = result.recognizedWords; 
        });
        _startSilenceTimer(); 
      },
    );
  }

  void _processResult() {
    _speech.stop(); 

    String jawaban = CommandService().generateResponse(_recognizedWords);

    setState(() {
      isListening = false;
      isResultAvailable = true;
      _teksHasilJawaban = jawaban; 
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
      _speech.stop(); 
    } else {
      _startListeningReal();
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
        Text('Tekan Layar', 
        style: TextStyle(
          fontSize: 60, 
          fontWeight: FontWeight.bold, 
          color: textWhite
          )),
        const SizedBox(height: 5),
        Text(
          'Tekan layar dimana pun',
           style: TextStyle(
            fontSize: 18,
             fontWeight: FontWeight.bold,
              color: textWhite)),
        const SizedBox(height: 30),
        _buildMicButton(),
        const SizedBox(height: 20),
        Text('Halo Pengguna!',
         style: TextStyle(
          fontSize: 25,
           fontWeight: FontWeight.bold,
            color: textWhite)),
      ],
    );
  }

  Widget _buildListeningUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitThreeBounce(color: neonYellow, size: 40.0),
        const SizedBox(height: 30),
       
        Text(
          _recognizedWords.isEmpty ? 'Mendengarkan...' : _recognizedWords,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textWhite
          ),
          textAlign: TextAlign.center,
        ),
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
            '"$_teksHasilJawaban"', 
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textWhite,
              height: 1.3
            ),
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