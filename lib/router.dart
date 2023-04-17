import 'package:flutter/material.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_details_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/edit_profile_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/home_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/login_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/profile_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/user_list_screen.dart';
import 'package:internship_practice/ui_pages.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case kLoginScreenPath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case kHomeScreenPath:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case kChatScreenPath:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case kProfileScreenPath:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case kChatDetailsScreenPath:
        return MaterialPageRoute(builder: (_) => const ChatDetailsScreen());
      case kEditProfileScreenPath:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case kUserListScreenPath:
        return MaterialPageRoute(builder: (_) => const UserListScreen());
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
