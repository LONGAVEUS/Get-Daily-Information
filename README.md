# NETRA: Asisten Suara Cerdas untuk Tunanetra

**NETRA** adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk membantu penyandang tunanetra mendapatkan informasi real-time (waktu, cuaca, dan lokasi detail) hanya melalui perintah suara, tanpa perlu berinteraksi dengan layar yang rumit.

---

## 📋 Daftar Isi
1. [Fitur Utama](#-fitur-utama)
2. [Teknologi & Dependencies](#-teknologi--dependencies)
3. [Arsitektur Proyek](#-arsitektur-proyek)
4. [Cara Menjalankan Aplikasi](#-cara-menjalankan-aplikasi)
5. [Konfigurasi & Izin (Permissions)](#-konfigurasi--izin-permissions)
6. [Tim Pengembang](#-tim-pengembang)

---

## ✨ Fitur Utama

- 🎙️ **Kontrol Penuh Melalui Suara:** Pengguna cukup mengetuk layar di mana saja untuk mengaktifkan mikrofon dan memberikan perintah.
- 🕒 **Informasi Waktu & Tanggal:** Membacakan jam dan tanggal hari ini secara real-time dari sistem perangkat.
- 🌦️ **Informasi Cuaca Lokal:** Mengambil data suhu dan kondisi cuaca terkini (Cerah, Hujan, Berawan, dll.) berdasarkan lokasi GPS pengguna.
- 📍 **Detail Lokasi Spesifik:** Tidak hanya menyebut nama kota, aplikasi mampu membacakan nama jalan, nama gedung/bangunan, dan wilayah sekitar pengguna (menggunakan Reverse Geocoding).
- ♿ **UI Aksesibel:** Desain High-Contrast (Hitam & Kuning Neon) dengan umpan balik getaran (*haptic feedback*) untuk memudahkan interaksi.

---

## 🛠️ Teknologi & Dependencies

Aplikasi ini dibangun menggunakan **Flutter** dan **Dart**, dengan memanfaatkan package dan API berikut:

- **State & UI:** `flutter_spinkit` (Animasi loading)
- **Voice Interaction:** `speech_to_text` (Speech-to-Text), `flutter_tts` (Text-to-Speech)
- **Location & Network:** `geolocator` (Akses GPS), `http` (HTTP Requests)
- **External APIs:** 
  - [Open-Meteo API](https://open-meteo.com/) (Data Cuaca Gratis & Open Source)
  - [Nominatim / OpenStreetMap](https://nominatim.org/) (Reverse Geocoding untuk detail lokasi)

---

## 📂 Arsitektur Proyek

Proyek ini menerapkan prinsip **Separation of Concerns (Pemisahan Tanggung Jawab)** agar kode bersih, mudah di-maintain, dan scalable:

```text
lib/
├── main.dart                 # Entry point aplikasi
├── home_page.dart            # Main UI & State Management (Gesture, TTS, STT)
├── services/                 # Business Logic & API Handling
│   ├── time_service.dart     # Logika pengambilan waktu & tanggal
│   ├── location_service.dart # Logika GPS & Nominatim API
│   ├── weather_service.dart  # Logika Open-Meteo API & penerjemah kode cuaca
│   └── command_service.dart  # "Otak" aplikasi: mencocokkan kata kunci suara ke service yang tepat
└── widgets/                  # Reusable UI Components
    ├── mic_button.dart
    ├── initial_view.dart
    ├── listening_view.dart
    └── result_view.dart
