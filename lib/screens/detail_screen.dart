import 'package:flutter/material.dart';

import '../kontak.dart';
import 'form_screen.dart';

class DetailScreen extends StatefulWidget {
  final Kontak kontak;

  const DetailScreen({super.key, required this.kontak});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Kontak _kontakSaatIni;
  bool _adaPerubahan = false;

  @override
  void initState() {
    super.initState();
    _kontakSaatIni = widget.kontak;
  }

  Future<void> _bukaFormEdit() async {
    final Kontak? hasilEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(kontakEdit: _kontakSaatIni),
      ),
    );

    if (hasilEdit != null) {
      setState(() {
        _kontakSaatIni = hasilEdit;
        _adaPerubahan = true;
      });
    }
  }

  void _konfirmasiHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kontak?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${_kontakSaatIni.nama}" dari daftar kontak?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(
                context,
                'hapus',
              ); // Kembali ke HomeScreen sambil kirim sinyal hapus
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _aksiCepat(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label ke ${_kontakSaatIni.nama}...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _adaPerubahan ? _kontakSaatIni : null);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _adaPerubahan ? _kontakSaatIni : null);
            },
          ),
          title: const Text(
            'Detail Kontak',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: _bukaFormEdit,
              tooltip: 'Edit Kontak',
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: _konfirmasiHapus,
              tooltip: 'Hapus Kontak',
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. Header Profil
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFF1E293B),
                child: Text(
                  _kontakSaatIni.inisial,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _kontakSaatIni.nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _kontakSaatIni.kategori,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Tombol Aksi Cepat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TombolAksi(
                    icon: Icons.call_outlined,
                    label: 'Telepon',
                    onTap: () => _aksiCepat('Menelepon'),
                  ),
                  _TombolAksi(
                    icon: Icons.chat_bubble_outline,
                    label: 'Pesan',
                    onTap: () => _aksiCepat('Mengirim pesan'),
                  ),
                  _TombolAksi(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onTap: () => _aksiCepat('Membuka email'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 3. Kartu Informasi Lengkap
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BarisInfo(
                      icon: Icons.phone_outlined,
                      judul: 'Nomor Telepon',
                      isi: _kontakSaatIni.nomorTelepon,
                    ),
                    Divider(height: 28, color: Colors.grey.shade200),
                    _BarisInfo(
                      icon: Icons.alternate_email,
                      judul: 'Email',
                      isi: _kontakSaatIni.email,
                    ),
                    Divider(height: 28, color: Colors.grey.shade200),
                    _BarisInfo(
                      icon: Icons.location_on_outlined,
                      judul: 'Alamat',
                      isi: _kontakSaatIni.alamat,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TombolAksi extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TombolAksi({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 92,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1E293B), size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarisInfo extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String isi;

  const _BarisInfo({
    required this.icon,
    required this.judul,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                isi,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
