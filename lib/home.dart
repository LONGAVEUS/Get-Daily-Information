import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tekan Layar',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Tekan layar dimana pun',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                side: BorderSide(
                  color: Color(0xFFE1FF00), // Warna kuning neon
                  width: 3, // Ketebalan garis border
                ),
              ),
              child: const Icon(
                Icons.graphic_eq, // Ganti dengan ikon pilihan Anda
                color: Color(0xFFE1FF00),
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Halo Pengguna!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
