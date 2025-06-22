import 'package:flutter/material.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/peserta/beranda/pembayaran_screen.dart';
class TransaksiScreen extends StatefulWidget {
  final Event event;
  
  const TransaksiScreen({
    super.key,
    required this.event,
  });

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  int quantity = 1;
  double get totalHarga => (widget.event.hargaTiket ?? 0) * quantity;
  // int get tipeTiket => (widget.event.tipeTiket ?? 0);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text(
          'Beli Tiket',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Info Card
            _buildEventInfoCard(isTablet),
            
            SizedBox(height: isTablet ? 24 : 20),
            
            // Quantity Selection
            _buildQuantitySection(isTablet),
            
            SizedBox(height: isTablet ? 24 : 20),
            
            // Price Summary
            _buildPriceSummary(isTablet),
            
            SizedBox(height: isTablet ? 32 : 24),
            
            // Buy Button
            _buildBuyButton(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfoCard(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
              child: Container(
                width: isTablet ? 80 : 70,
                height: isTablet ? 80 : 70,
                child: Image.network(
                  widget.event.fotoUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: isTablet ? 32 : 28,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: isTablet ? 16 : 12),
            
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.judul ?? 'Judul Event',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    widget.event.tanggalEvent ?? '-',
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 4 : 3),
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    widget.event.jamMulai ?? '-',
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 4 : 3),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    widget.event.lokasi ?? '-',
                    isTablet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isTablet) {
    return Row(
      children: [
        Icon(
          icon, 
          size: isTablet ? 14 : 12, 
          color: Colors.grey.shade600,
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySection(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jumlah Tiket',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            
            // Ticket Type Info
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.confirmation_num_outlined,
                    color: Colors.blue.shade600,
                    size: isTablet ? 20 : 18,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tipeTiketText(widget.event.tipeTiket ?? 0),
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        Text(
                          'Rp ${(widget.event.hargaTiket ?? 0).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: isTablet ? 16 : 12),
            
            // Quantity Selector
            Row(
              children: [
                Text(
                  'Jumlah:',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                  ),
                  child: Row(
                    children: [
                      // Decrease Button
                      InkWell(
                        onTap: quantity > 1 ? () {
                          setState(() {
                            quantity--;
                          });
                        } : null,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(isTablet ? 10 : 8),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 12 : 10),
                          child: Icon(
                            Icons.remove,
                            size: isTablet ? 20 : 18,
                            color: quantity > 1 ? Colors.blue.shade600 : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      
                      // Quantity Display
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 12 : 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      
                      // Increase Button
                      InkWell(
                        onTap: quantity < 10 ? () {
                          setState(() {
                            quantity++;
                          });
                        } : null,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(isTablet ? 10 : 8),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 12 : 10),
                          child: Icon(
                            Icons.add,
                            size: isTablet ? 20 : 18,
                            color: quantity < 10 ? Colors.blue.shade600 : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isTablet ? 8 : 6),
            
            // Quantity Limit Info
            Text(
              'Maksimal 10 tiket per transaksi',
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Pembayaran',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            
            // Price per ticket
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harga per tiket',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Rp ${(widget.event.hargaTiket ?? 0).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isTablet ? 8 : 6),
            
            // Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah tiket',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '$quantity tiket',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isTablet ? 12 : 10),
            
            Divider(color: Colors.grey.shade300),
            
            SizedBox(height: isTablet ? 12 : 10),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Rp ${totalHarga.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyButton(bool isTablet) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _handleBuyTicket();
        },
        icon: const Icon(
          Icons.payment_outlined,
          size: 20,
        ),
        label: Text(
          'Lanjutkan Pembayaran',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 16 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  String _tipeTiketText(int tipe) {
    switch (tipe) {
      case 1:
        return 'Tiket Gratis';
      case 2:
        return 'Tiket Berbayar';
      default:
        return 'Tiket Tidak Diketahui';
    }
  }

  void _handleBuyTicket() {
   
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Membeli $quantity tiket untuk ${widget.event.judul} - Total: Rp ${totalHarga.toStringAsFixed(0)}',
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Example: Navigate to payment screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          event: widget.event,
          quantity: quantity,
        ),
      ),
    );
  }
}