class Bencana {
  final int? id;
  final String namaBencana;
  final String lokasi;
  final String deskripsi;
  final String status;

  Bencana({this.id, required this.namaBencana, required this.lokasi, required this.deskripsi, required this.status});

  factory Bencana.fromJson(Map<String, dynamic> json) {
    return Bencana(
      id: json['id'],
      namaBencana: json['nama_bencana'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_bencana': namaBencana,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}