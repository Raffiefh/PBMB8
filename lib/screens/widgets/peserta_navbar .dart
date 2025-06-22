import 'package:flutter/material.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/screens/peserta/akun/akun_screen.dart';
import 'package:pbmuas/screens/peserta/beranda/beranda_screen.dart';
import 'package:pbmuas/screens/forum/forum_screen.dart';
import 'package:pbmuas/screens/peserta/tiket/tiket_screen.dart';
class NavbarPeserta extends StatefulWidget {
  final int initialIndex;
  const NavbarPeserta({super.key, this.initialIndex = 0});

  @override
  State<NavbarPeserta> createState() => _NavbarPesertaState();
}

class _NavbarPesertaState extends State<NavbarPeserta> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // <- Ambil index dari parameter
    Future.microtask(() {
      final authVModel = Provider.of<AuthVModel>(context, listen: false);
      authVModel.loadUserFromSession();
    });
  }

  final List<Widget> _pages = [
    const BerandaPeserta(),
    const ForumContent(),
    const TiketPeserta(),
    const AkunPeserta(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tiket'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
      ),
    );
  }
}
