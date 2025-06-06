import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';
@JsonSerializable()
class Event {
  final int id;
  final String judul;
  final String deskripsi;

  @JsonKey(name: 'tanggal_event')
  final String tanggalEvent;

  @JsonKey(name: 'jam_mulai')
  final String jamMulai;

  @JsonKey(name: 'durasi_event')
  final int durasiEvent;

  @JsonKey(name: 'tipe_tiket')
  final int tipeTiket;

  @JsonKey(name: 'jumlah_tiket')
  final int jumlahTiket;

  @JsonKey(name: 'harga_tiket')
  final double? hargaTiket;    
  
  
  final String lokasi;
  final double latitude;      
  final double longitude;   

  @JsonKey(name: 'foto_url')  
  final String fotoUrl;

  @JsonKey(name: 'akun_id')
  final int akunId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  Event({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggalEvent,
    required this.jamMulai,
    required this.durasiEvent,
    required this.tipeTiket,
    required this.jumlahTiket,
    this.hargaTiket,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    required this.fotoUrl,
    required this.akunId,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
