import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/pages/radio_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [RadioPage(), Text("Page 2")];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          _bottomNavItem(Icons.play_arrow, "Listen"),
          _bottomNavItem(Icons.favorite, "Favorite"),
        ],
        onTap: onTabTapped,
      ),
    ));
  }

  onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _bottomNavItem(IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Color(0xff6d7381),
      ),
      activeIcon: Icon(
        icon,
        color: Colors.white,
      ),
      label: title,
    );
  }
}
