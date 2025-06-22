class PaymentResponse {
  String? snapToken;
  String? redirectUrl;
  final String orderId;
  final double hargaTotal;
  final List<TiketQr> tiketQr;

  PaymentResponse({
    this.snapToken,
    this.redirectUrl,
    required this.orderId,
    required this.hargaTotal,
    required this.tiketQr,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      snapToken: json['snap_token'],
      redirectUrl: json['redirect_url'],
      orderId: json['order_id'],
      hargaTotal: (json['harga_total'] as num).toDouble(),
      tiketQr: (json['tiket_qr'] as List)
          .map((e) => TiketQr.fromJson(e))
          .toList(),
    );
  }
}

class TiketQr {
  final String qrCode;
  final String status;

  TiketQr({required this.qrCode, required this.status});

  factory TiketQr.fromJson(Map<String, dynamic> json) {
    return TiketQr(
      qrCode: json['qr_code'],
      status: json['status'],
    );
  }
}
