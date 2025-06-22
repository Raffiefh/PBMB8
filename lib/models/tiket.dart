class RiwayatTiket {
  final String qrCode;
  final String status;
  final EventTransaksi transaksi;

  RiwayatTiket({required this.qrCode, required this.status, required this.transaksi});

  factory RiwayatTiket.fromJson(Map<String, dynamic> json) {
    return RiwayatTiket(
      qrCode: json['qr_code'],
      status: json['status'],
      transaksi: EventTransaksi.fromJson(json['transaksi']),
    );
  }
}

class EventTransaksi {
  final EventDetail event;

  EventTransaksi({required this.event});

  factory EventTransaksi.fromJson(Map<String, dynamic> json) {
     return EventTransaksi(
      event: EventDetail.fromJson(json['event']),
    );
  }
}

class EventDetail {
  final int id;
  final String judul;
  final String tanggalEvent;
  final String jamMulai;
  final String lokasi;
  final String fotoUrl;

  EventDetail({
    required this.id,
    required this.judul,
    required this.tanggalEvent,
    required this.jamMulai,
    required this.lokasi,
    required this.fotoUrl,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'],
      judul: json['judul'],
      tanggalEvent: json['tanggal_event'],
      jamMulai: json['jam_mulai'],
      lokasi: json['lokasi'],
      fotoUrl: json['foto_url'],
    );
  }
}
