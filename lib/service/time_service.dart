class TimeService {
  String getCurrentTime() {
    DateTime now = DateTime.now();
    return "Sekarang Menunjukan Pukul ${now.hour} lewat ${now.minute} menit";
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    List<String> namaHari = [
      "",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu"
    ];
    List<String> namaBulan = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return "Hari ini adalah hari ${namaHari[now.weekday]}, tanggal ${now.day} ${namaBulan[now.month]} ${now.year}";
  }
}
