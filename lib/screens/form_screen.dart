import 'package:flutter/material.dart';

import '../kontak.dart';

class FormScreen extends StatefulWidget {
  final Kontak? kontakEdit;

  const FormScreen({super.key, this.kontakEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  String _kategoriTerpilih = 'Teman';

  final List<String> _opsiKategori = ['Keluarga', 'Teman', 'Kampus', 'Kerja'];

  bool get _isModeEdit => widget.kontakEdit != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.kontakEdit?.nama ?? '',
    );
    _teleponController = TextEditingController(
      text: widget.kontakEdit?.nomorTelepon ?? '',
    );
    _emailController = TextEditingController(
      text: widget.kontakEdit?.email ?? '',
    );
    _alamatController = TextEditingController(
      text: widget.kontakEdit?.alamat ?? '',
    );

    if (widget.kontakEdit != null &&
        _opsiKategori.contains(widget.kontakEdit!.kategori)) {
      _kategoriTerpilih = widget.kontakEdit!.kategori;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _simpanKontak() {
    if (_formKey.currentState!.validate()) {
      final kontakHasil = Kontak(
        nama: _namaController.text.trim(),
        nomorTelepon: _teleponController.text.trim(),
        email: _emailController.text.trim(),
        kategori: _kategoriTerpilih,
        alamat: _alamatController.text.trim(),
      );
      Navigator.pop(context, kontakHasil);
    }
  }

  InputDecoration _dekorasiInput(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isModeEdit ? 'Edit Kontak' : 'Tambah Kontak Baru',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _namaController,
              textCapitalization: TextCapitalization.words,
              decoration: _dekorasiInput(
                'Nama Lengkap',
                'Contoh: Budi Santoso',
                Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama lengkap wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teleponController,
              keyboardType: TextInputType.phone,
              decoration: _dekorasiInput(
                'Nomor Telepon',
                'Contoh: 0812-3456-7890',
                Icons.phone_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nomor telepon wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _dekorasiInput(
                'Email',
                'Contoh: budi@email.com',
                Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!value.contains('@')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategoriTerpilih,
              decoration: _dekorasiInput(
                'Kategori',
                'Pilih kategori',
                Icons.label_outline,
              ),
              items: _opsiKategori.map((kategori) {
                return DropdownMenuItem(value: kategori, child: Text(kategori));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _kategoriTerpilih = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _dekorasiInput(
                'Alamat',
                'Masukkan alamat lengkap',
                Icons.location_on_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Alamat wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _simpanKontak,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isModeEdit ? 'Simpan Perubahan' : 'Simpan Kontak',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
