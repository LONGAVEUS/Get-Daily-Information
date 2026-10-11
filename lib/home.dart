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

  Future<void> _startDelayToResult() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted && isListening) {
      setState(() {
        isListening = false;
        isResultAvailable = true;
      });
      HapticFeedback.heavyImpact();
      _tts.speak("Sekarang pukul 10.30 pagi, cuaca cerah.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundBlack,
          border: Border.all(color: neonYellow, width: 4.0),
          borderRadius: BorderRadius.circular(35),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.mediumImpact();
              if (isResultAvailable) {
                setState(() {
                  isResultAvailable = false;
                });
              } else if (!isListening) {
                setState(() {
                  isListening = !isListening;
                });
                if (isListening) {
                  _startDelayToResult();
                }
              }
            },
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
        Text(
          'Tekan Layar',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: textWhite,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Tekan layar dimana pun',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textWhite,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isListening = !isListening;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundBlack,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(30),
            side: BorderSide(color: neonYellow, width: 3),
          ),
          child: Icon(Icons.graphic_eq, color: neonYellow, size: 32),
        ),
        const SizedBox(height: 20),
        Text(
          'Halo Pengguna!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: textWhite,
          ),
        ),
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
          'Mendengarkan...',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildResultUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isListening = false;
              isResultAvailable = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundBlack,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(30),
            side: BorderSide(color: neonYellow, width: 3),
          ),
          child: Icon(Icons.graphic_eq, color: neonYellow, size: 32),
        ),

        const SizedBox(height: 30),

        Text(
          '"Sekarang pukul 10.30 pagi, cuaca cerah."',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textWhite,
            height: 1.3, 
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
