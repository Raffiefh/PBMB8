// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  id: (json['id'] as num).toInt(),
  judul: json['judul'] as String,
  deskripsi: json['deskripsi'] as String,
  tanggalEvent: json['tanggal_event'] as String,
  jamMulai: json['jam_mulai'] as String,
  durasiEvent: (json['durasi_event'] as num).toInt(),
  tipeTiket: (json['tipe_tiket'] as num).toInt(),
  jumlahTiket: (json['jumlah_tiket'] as num).toInt(),
  hargaTiket: (json['harga_tiket'] as num?)?.toDouble(),
  lokasi: json['lokasi'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  fotoUrl: json['foto_url'] as String,
  akunId: (json['akun_id'] as num).toInt(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'id': instance.id,
  'judul': instance.judul,
  'deskripsi': instance.deskripsi,
  'tanggal_event': instance.tanggalEvent,
  'jam_mulai': instance.jamMulai,
  'durasi_event': instance.durasiEvent,
  'tipe_tiket': instance.tipeTiket,
  'jumlah_tiket': instance.jumlahTiket,
  'harga_tiket': instance.hargaTiket,
  'lokasi': instance.lokasi,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'foto_url': instance.fotoUrl,
  'akun_id': instance.akunId,
  'created_at': instance.createdAt,
};
