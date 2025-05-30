import 'package:flutter/material.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/screens/peserta/akun/akun_screen.dart';
import 'package:pbmuas/screens/peserta/beranda/beranda_screen.dart';
import 'package:pbmuas/screens/forum/forum_screen.dart';
import 'package:pbmuas/screens/peserta/tiket/tiket_screen.dart';
class NavbarPeserta extends StatefulWidget {
  const NavbarPeserta({super.key});

  @override
  State<NavbarPeserta> createState() => _NavbarPesertaState();
}

class _NavbarPesertaState extends State<NavbarPeserta> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
    final size = MediaQuery.of(context).size;
    final navHeight = size.height * 0.1;
    final iconSize = size.width * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_selectedIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: navHeight,
              padding: EdgeInsets.only(top: navHeight * 0.1),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color.fromARGB(255, 155, 201, 238))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(Icons.home, "Beranda", 0, iconSize),
                  _navItem(Icons.forum, "Forum", 1, iconSize),
                  _navItem(Icons.confirmation_num, "Tiketku", 2, iconSize),
                  _navItem(Icons.account_circle, "Akun", 3, iconSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, double iconSize) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? iconSize * 1.35 : iconSize,
            color: isSelected ? Colors.blue : Colors.grey[400],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: iconSize * 0.42,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 1),
          if (isSelected)
            Container(
              height: 3,
              width: 30,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}
