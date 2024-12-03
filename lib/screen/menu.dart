import 'package:flutter/material.dart';
import 'screen.dart';
import '../config/pallete.dart';
import '../widget/widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
  final List<Widget> _pages = [
    const Center(child: HomePage()),
    const Center(child: SeatsPage()),
    const Center(child: BookingPage()),
    const Center(child: Text('11')),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 6, 1, 1).withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedFontSize: 0,
            currentIndex: _currentIndex, // Index saat ini
            onTap: _onTabTapped, // Mengubah halaman saat tab ditekan
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem('home', 0),
              _buildNavItem('search', 1),
              _buildNavItem('grid', 2),
              _buildNavItem('profile', 3),
            ],
            selectedItemColor:
                Theme.of(context).primaryColor, // Warna item yang dipilih
            unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String icon, int index) {
    bool isActive = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34.0),
        child: SizedBox(
          height: 24,
          child: Stack(
            children: [
              Visibility(
                visible: isActive,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Pallete.cyan.withOpacity(0.6), // Glow color
                        blurRadius: 20, // Spread of the glow
                        spreadRadius: 2, // Intensity of the glow
                      ),
                    ],
                  ),
                ),
              ),
              AppSvgIcon(
                icon,
                color: !isActive ? Pallete.grey1 : Pallete.cyan,
              ),
            ],
          ),
        ),
      ),
      label: '',
    );
  }
}
