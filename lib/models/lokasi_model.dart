class LokasiModel {
  final int? id;
  final String nama;
  final String? deskripsi;
  final String? alamat;
  final String? foto; // path ke file foto
  final double latitude;
  final double longitude;
  final String? tanggal;
  final String? jamBuka;
  final String? jamTutup;

  LokasiModel({
    this.id,
    required this.nama,
    this.deskripsi,
    this.alamat,
    this.foto,
    required this.latitude,
    required this.longitude,
    this.tanggal,
    this.jamBuka,
    this.jamTutup,
  });

  LokasiModel copyWith({
    int? id,
    String? nama,
    String? deskripsi,
    String? alamat,
    String? foto,
    double? latitude,
    double? longitude,
    String? tanggal,
    String? jamBuka,
    String? jamTutup,
  }) {
    return LokasiModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      alamat: alamat ?? this.alamat,
      foto: foto ?? this.foto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tanggal: tanggal ?? this.tanggal,
      jamBuka: jamBuka ?? this.jamBuka,
      jamTutup: jamTutup ?? this.jamTutup,
    );
  }

  factory LokasiModel.fromMap(Map<String, dynamic> m) {
    return LokasiModel(
      id: m['id'] as int?,
      nama: m['nama'] as String? ?? '',
      deskripsi: m['deskripsi'] as String?,
      alamat: m['alamat'] as String?,
      foto: m['foto'] as String?,
      latitude: (m['latitude'] as num).toDouble(),
      longitude: (m['longitude'] as num).toDouble(),
      tanggal: m['tanggal'] as String?,
      jamBuka: m['jam_buka'] as String?,
      jamTutup: m['jam_tutup'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'alamat': alamat,
      'foto': foto,
      'latitude': latitude,
      'longitude': longitude,
      'tanggal': tanggal,
      'jam_buka': jamBuka,
      'jam_tutup': jamTutup,
    };
  }
}
