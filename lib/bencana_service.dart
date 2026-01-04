import 'package:dio/dio.dart';
import 'bencana.dart';

class BencanaService {
  // Menggunakan BaseOptions seperti pada project Agenda Anda
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000/api', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Bencana>> getBencana() async {
    try {
      final response = await _dio.get('/bencana');
      return (response.data as List)
          .map((json) => Bencana.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat data bencana: $e');
    }
  }

  Future<void> addBencana(Bencana bencana) async {
    try {
      await _dio.post('/bencana', data: bencana.toJson());
    } catch (e) {
      throw Exception('Gagal menambah laporan: $e');
    }
  }

  Future<void> updateBencana(int id, Bencana bencana) async {
    try {
      await _dio.put('/bencana/$id', data: bencana.toJson());
    } catch (e) {
      throw Exception('Gagal mengupdate laporan: $e');
    }
  }

  Future<void> deleteBencana(int id) async {
    try {
      await _dio.delete('/bencana/$id');
    } catch (e) {
      throw Exception('Gagal menghapus laporan: $e');
    }
  }
}