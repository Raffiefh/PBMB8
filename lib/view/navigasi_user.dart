import 'package:flutter/material.dart';
import 'homepage_user.dart';
import 'riwayat_user.dart';
import 'forum_user.dart';
import 'akun_user.dart';

class NavigasiUser extends StatefulWidget {
  const NavigasiUser({super.key});

  @override
  State<NavigasiUser> createState() => _NavigasiUserState();
}

class _NavigasiUserState extends State<NavigasiUser> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomepageUser(),
    RiwayatUser(),
    ForumUser(),
    AkunUser(),
  ];

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
                  _navItem(Icons.history, "Riwayat", 1, iconSize),
                  _navItem(Icons.forum, "Forum", 2, iconSize),
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
