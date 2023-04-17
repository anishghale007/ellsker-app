import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/home_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/profile_screen.dart';
import 'package:internship_practice/ui_pages.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  Future<bool> _showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout from APP'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              AuthRemoteDataSourceImpl().signOut();
              Navigator.pushReplacementNamed(context, kLoginScreenPath);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: Scaffold(
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
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
