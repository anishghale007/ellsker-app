import 'package:flutter/material.dart';
import 'package:internship_practice/features/auth/presentation/pages/bottom_nav_bar_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:internship_practice/features/location/presentation/pages/location_screen.dart';
import 'package:internship_practice/features/location/presentation/pages/map_screen.dart';
import 'package:internship_practice/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/festival_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/login_screen.dart';
import 'package:internship_practice/features/profile/presentation/pages/profile_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/user_list_screen.dart';
import 'package:internship_practice/ui_pages.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case kLoginScreenPath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case kBottomNavBarPath:
        return MaterialPageRoute(builder: (_) => const BottomNavBarScreen());
      case kHomeScreenPath:
        return MaterialPageRoute(builder: (_) => const FestivalScreen());
      case kChatListScreenPath:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case kProfileScreenPath:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case kEditProfileScreenPath:
        return MaterialPageRoute(builder: (_) {
          Map<String, dynamic> arguments =
              routeSettings.arguments as Map<String, dynamic>;
          return EditProfileScreen(
            photoUrl: arguments['photoUrl'],
            username: arguments['username'],
            instagram: arguments['instagram'],
            location: arguments['location'],
            age: arguments['age'],
          );
        });
      case kUserListScreenPath:
        return MaterialPageRoute(builder: (_) => const UserListScreen());
      case kChatScreenPath:
        return MaterialPageRoute(builder: (_) {
          Map<String, dynamic> arguments =
              routeSettings.arguments as Map<String, dynamic>;
          return ChatScreen(
            username: arguments["username"],
            userId: arguments["userId"],
            photoUrl: arguments["photoUrl"],
            token: arguments['token'],
          );
        });
      case kLocationScreenPath:
        return MaterialPageRoute(builder: (_) => const LocationScreen());
      case kMapScreenPath:
        return MaterialPageRoute(builder: (_) {
          Map<String, dynamic> arguments =
              routeSettings.arguments as Map<String, dynamic>;
          return MapScreen(
            userLatitude: arguments["userLatitude"],
            userLongitude: arguments["userLongitude"],
            username: arguments["username"],
          );
        });
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
