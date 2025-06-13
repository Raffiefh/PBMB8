import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';
@JsonSerializable()
class Event {
  final int? id;
  final String? judul;
  final String? deskripsi;

  @JsonKey(name: 'tanggal_event')
  final String? tanggalEvent;

  @JsonKey(name: 'jam_mulai')
  final String? jamMulai;

  @JsonKey(name: 'durasi_event')
  final int? durasiEvent;

  @JsonKey(name: 'tipe_tiket')
  final int? tipeTiket;

  @JsonKey(name: 'jumlah_tiket')
  final int? jumlahTiket;

  @JsonKey(name: 'harga_tiket')
  final double? hargaTiket;    
  
  
  final String? lokasi;
  final double? latitude;      
  final double? longitude;   

  @JsonKey(name: 'foto_url')  
  final String? fotoUrl;

  @JsonKey(name: 'akun_id')
  final int? akunId;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  Event({
    this.id,
    this.judul,
    this.deskripsi,
    this.tanggalEvent,
    this.jamMulai,
    this.durasiEvent,
    this.tipeTiket,
    this.jumlahTiket,
    this.hargaTiket,
    this.lokasi,
    this.latitude,
    this.longitude,
    this.fotoUrl,
    this.akunId,
    this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
