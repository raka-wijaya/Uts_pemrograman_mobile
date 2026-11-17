import 'package:flutter/material.dart';

import '../kontak.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Menyalin data awal dari kontak.dart agar bisa ditambah/edit/hapus di UI
  late List<Kontak> _semuaKontak;
  String _kataKunci = '';
  String _kategoriTerpilih = 'Semua';

  final List<String> _daftarKategori = [
    'Semua',
    'Keluarga',
    'Teman',
    'Kampus',
    'Kerja',
  ];

  @override
  void initState() {
    super.initState();
    _semuaKontak = List<Kontak>.from(daftarKontak);
  }

  List<Kontak> get _kontakTersaring {
    return _semuaKontak.where((kontak) {
      final cocokKategori =
          _kategoriTerpilih == 'Semua' ||
          kontak.kategori.toLowerCase() == _kategoriTerpilih.toLowerCase();

      final query = _kataKunci.toLowerCase();
      final cocokPencarian =
          kontak.nama.toLowerCase().contains(query) ||
          kontak.nomorTelepon.toLowerCase().contains(query) ||
          kontak.email.toLowerCase().contains(query);

      return cocokKategori && cocokPencarian;
    }).toList();
  }

  Future<void> _bukaFormTambah() async {
    final Kontak? kontakBaru = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormScreen()),
    );

    if (kontakBaru != null) {
      setState(() {
        _semuaKontak.insert(0, kontakBaru);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${kontakBaru.nama} berhasil ditambahkan')),
      );
    }
  }

  Future<void> _bukaDetail(Kontak kontak) async {
    final indexAsli = _semuaKontak.indexOf(kontak);
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(kontak: kontak)),
    );

    if (hasil == 'hapus' && indexAsli != -1) {
      setState(() {
        _semuaKontak.removeAt(indexAsli);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${kontak.nama} dihapus')));
    } else if (hasil is Kontak && indexAsli != -1) {
      setState(() {
        _semuaKontak[indexAsli] = hasil;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan kontak disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasilFilter = _kontakTersaring;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Kontak',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              '${_semuaKontak.length} kontak tersimpan',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _kataKunci = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama, nomor, atau email...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF1E293B),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // 2. Filter Chips Kategori
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _daftarKategori.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final kategori = _daftarKategori[index];
                final isSelected = _kategoriTerpilih == kategori;

                return ChoiceChip(
                  label: Text(kategori),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _kategoriTerpilih = kategori;
                    });
                  },
                  selectedColor: const Color(0xFF1E293B),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1E293B)
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 3. List Kontak / Empty State
          Expanded(
            child: hasilFilter.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kontak tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba kata kunci lain atau tambah kontak baru',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                    itemCount: hasilFilter.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final kontak = hasilFilter[index];
                      return _KartuKontak(
                        kontak: kontak,
                        onTap: () => _bukaDetail(kontak),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambah,
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _KartuKontak extends StatelessWidget {
  final Kontak kontak;
  final VoidCallback onTap;

  const _KartuKontak({required this.kontak, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Text(
                kontak.inisial,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kontak.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kontak.nomorTelepon,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                kontak.kategori,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
