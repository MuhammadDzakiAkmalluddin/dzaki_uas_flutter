import 'package:flutter/material.dart';
import 'bencana.dart';
import 'bencana_service.dart';

class BencanaForm extends StatefulWidget {
  final Bencana? bencana;
  const BencanaForm({super.key, this.bencana});

  @override
  State<BencanaForm> createState() => _BencanaFormState();
}

class _BencanaFormState extends State<BencanaForm> {
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _status = 'Waspada';
  final _service = BencanaService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.bencana != null) {
      _namaController.text = widget.bencana!.namaBencana;
      _lokasiController.text = widget.bencana!.lokasi;
      _deskripsiController.text = widget.bencana!.deskripsi;
      _status = widget.bencana!.status;
    }
  }

  // FIX: Input Style Murni HITAM - MERAH
  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF1A1A1A), // Latar input hitam gelap
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24), 
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 2), // Fokus MERAH
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.bencana != null;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background Body HITAM
      appBar: AppBar(
        title: Text(isEdit ? 'EDIT LAPORAN' : 'TAMBAH LAPORAN', 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFB71C1C), // Appbar MERAH
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Label MERAH
            const Text("Jenis Bencana", 
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle('Contoh: Banjir'),
            ),
            const SizedBox(height: 20),

            const Text("Lokasi Kejadian", 
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _lokasiController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle('Masukkan alamat'),
            ),
            const SizedBox(height: 20),

            const Text("Deskripsi", 
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: _inputStyle('Keterangan...'),
            ),
            const SizedBox(height: 20),

            const Text("Status Peringatan", 
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _status,
                isExpanded: true,
                dropdownColor: const Color(0xFF1A1A1A),
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB71C1C)),
                items: ['Waspada', 'Siaga', 'Awas'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol MERAH
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _isLoading ? null : _handleSave,
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(isEdit ? 'UPDATE DATA' : 'KIRIM LAPORAN', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_namaController.text.isEmpty || _lokasiController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final data = Bencana(
        namaBencana: _namaController.text,
        lokasi: _lokasiController.text,
        deskripsi: _deskripsiController.text,
        status: _status,
      );
      if (widget.bencana != null) {
        await _service.updateBencana(widget.bencana!.id!, data);
      } else {
        await _service.addBencana(data);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
}