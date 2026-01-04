import 'package:flutter/material.dart';
import 'bencana.dart';
import 'bencana_service.dart';
import 'bencana_form.dart';

class BencanaPage extends StatefulWidget {
  const BencanaPage({super.key});

  @override
  State<BencanaPage> createState() => _BencanaPageState();
}

class _BencanaPageState extends State<BencanaPage> {
  final BencanaService _service = BencanaService();
  late Future<List<Bencana>> _bencanaFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _bencanaFuture = _service.getBencana();
    });
  }

  void _showSuccessSnack(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: const Color(0xFFB71C1C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, Bencana item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Konfirmasi Hapus", style: TextStyle(color: Color(0xFFB71C1C))),
          content: Text("Yakin ingin menghapus laporan ${item.namaBencana}?", 
            style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _service.deleteBencana(item.id!);
                  _showSuccessSnack("Laporan berhasil dihapus!", Icons.delete_sweep);
                  _refresh();
                } catch (e) {
                  _showSuccessSnack("Gagal menghapus: $e", Icons.error_outline);
                }
              },
              child: const Text("HAPUS"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        title: const Text('DATA BENCANA ALAM', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFFB71C1C),
        centerTitle: true,
        elevation: 5,
      ),
      body: FutureBuilder<List<Bencana>>(
        future: _bencanaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C)));
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi Kesalahan: ${snapshot.error}", style: const TextStyle(color: Colors.white54)));
          }

          final listBencana = snapshot.data ?? [];

          if (listBencana.isEmpty) {
            return const Center(child: Text('Tidak ada laporan bencana', style: TextStyle(color: Colors.white54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: listBencana.length,
            itemBuilder: (context, index) {
              final item = listBencana[index];
              return Card(
                color: const Color(0xFF1A1A1A),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFFB71C1C), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFB71C1C),
                    child: Icon(Icons.warning_amber_rounded, color: Colors.white),
                  ),
                  title: Text(item.namaBencana, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text("${item.lokasi}\nStatus: ${item.status}", style: const TextStyle(color: Colors.white70)),
                  ),
                  // Trailing dengan Row agar Ikon Pena dan Sampah sejajar
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BencanaForm(bencana: item)),
                          );
                          if (result == true) {
                            _refresh();
                            _showSuccessSnack("Data berhasil diperbarui!", Icons.edit_note);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFB71C1C)),
                        onPressed: () => _konfirmasiHapus(context, item),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BencanaForm()),
          );
          if (result == true) {
            _refresh();
            _showSuccessSnack("Laporan berhasil ditambahkan!", Icons.cloud_done_outlined);
          }
        },
        backgroundColor: const Color(0xFFB71C1C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("TAMBAH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}