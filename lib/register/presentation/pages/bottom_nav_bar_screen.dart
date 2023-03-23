import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/register/presentation/pages/chat_screen.dart';
import 'package:internship_practice/register/presentation/pages/home_screen.dart';
import 'package:internship_practice/register/presentation/pages/profile_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          backgroundColor: ColorUtil.kSecondaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: ColorUtil.kTertiaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              tooltip: "Home",
              label: "Home",
              activeIcon: Icon(
                Icons.window,
              ),
              icon: Icon(
                Icons.window_outlined,
              ),
            ),
            BottomNavigationBarItem(
              tooltip: "Chat",
              label: "Chat",
              activeIcon: Icon(
                Icons.message,
              ),
              icon: Icon(
                Icons.message_outlined,
              ),
            ),
            BottomNavigationBarItem(
              tooltip: "Profile",
              label: "Profile",
              activeIcon: Icon(Icons.person),
              icon: Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
