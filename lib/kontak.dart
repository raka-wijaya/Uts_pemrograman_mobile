class Kontak {
  final String nama;
  final String nomorTelepon;
  final String email;
  final String kategori; // contoh: Keluarga, Teman, Kampus, Kerja
  final String alamat;

  const Kontak({
    required this.nama,
    required this.nomorTelepon,
    required this.email,
    required this.kategori,
    required this.alamat,
  });

  /// Inisial nama (maks. 2 huruf) untuk ditampilkan di CircleAvatar.
  /// Contoh: "Budi Santoso" -> "BS"
  String get inisial {
    final bagian = nama.trim().split(' ');
    if (bagian.length == 1) return bagian.first[0].toUpperCase();
    return (bagian.first[0] + bagian.last[0]).toUpperCase();
  }
}

const List<Kontak> daftarKontak = [
  Kontak(
    nama: 'Marudin new',
    nomorTelepon: '0812-3456-7801',
    email: 'dindin@email.com',
    kategori: 'Keluarga',
    alamat: 'Jl. Pahlawan No. 12, Sidoarjo',
  ),
  Kontak(
    nama: 'Sitiw',
    nomorTelepon: '0813-2345-6702',
    email: 'siti.aminah@email.com',
    kategori: 'Keluarga',
    alamat: 'Jl. Diponegoro No. 5, Surabaya',
  ),
  Kontak(
    nama: 'harum hanum',
    nomorTelepon: '0857-1122-3303',
    email: 'rnum@email.com',
    kategori: 'Teman',
    alamat: 'Perum Griya Asri Blok C3, Gresik',
  ),
  Kontak(
    nama: 'Dewi persik',
    nomorTelepon: '0821-4455-6604',
    email: 'dewip@email.com',
    kategori: 'Teman',
    alamat: 'Jl. Raya Waru No. 21, Sidoarjo',
  ),
  Kontak(
    nama: 'pengacara pgsd',
    nomorTelepon: '0878-9900-1105',
    email: 'anwar@umsida.ac.id',
    kategori: 'Kampus',
    alamat: 'Kampus 1 UMSIDA, Sidoarjo',
  ),
  Kontak(
    nama: 'Ahmad Fauzi',
    nomorTelepon: '0896-7788-9906',
    email: 'ahmad.fauzi@email.com',
    kategori: 'Kampus',
    alamat: 'Jl. Mojopahit No. 8, Sidoarjo',
  ),
  Kontak(
    nama: 'Putri Maharani',
    nomorTelepon: '0852-3344-5507',
    email: 'putri.maharani@email.com',
    kategori: 'Kerja',
    alamat: 'Jl. Ahmad Yani No. 77, Surabaya',
  ),
  Kontak(
    nama: 'Hendra Wijaya',
    nomorTelepon: '0838-6677-8808',
    email: 'hendra.wijaya@email.com',
    kategori: 'Kerja',
    alamat: 'Jl. Raya Gubeng No. 30, Surabaya',
  ),
  Kontak(
    nama: 'Nur Aisyah',
    nomorTelepon: '0819-1010-2009',
    email: 'nur.aisyah@email.com',
    kategori: 'Teman',
    alamat: 'Jl. Veteran No. 14, Gresik',
  ),
  Kontak(
    nama: 'Bambang Sutrisno',
    nomorTelepon: '0877-5566-7710',
    email: 'bambang.sutrisno@email.com',
    kategori: 'Keluarga',
    alamat: 'Jl. Kenjeran No. 3, Surabaya',
  ),
];