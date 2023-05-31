// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i13;

import '../features/auth/presentation/pages/festival_screen.dart' as _i6;
import '../features/auth/presentation/pages/home_screen.dart' as _i1;
import '../features/auth/presentation/pages/login_screen.dart' as _i2;
import '../features/chat/presentation/pages/chat_list_screen.dart' as _i9;
import '../features/chat/presentation/pages/chat_screen.dart' as _i3;
import '../features/chat/presentation/pages/media_files_screen.dart' as _i5;
import '../features/chat/presentation/pages/user_list_screen.dart' as _i10;
import '../features/location/presentation/pages/location_screen.dart' as _i8;
import '../features/location/presentation/pages/map_screen.dart' as _i4;
import '../features/profile/presentation/pages/edit_profile_screen.dart'
    as _i12;
import '../features/profile/presentation/pages/profile_screen.dart' as _i11;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.ChatScreen(
          username: args.username,
          userId: args.userId,
          photoUrl: args.photoUrl,
          token: args.token,
          key: args.key,
        ),
      );
    },
    MapRoute.name: (routeData) {
      final args =
          routeData.argsAs<MapRouteArgs>(orElse: () => const MapRouteArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.MapScreen(
          key: args.key,
          username: args.username,
          userLatitude: args.userLatitude,
          userLongitude: args.userLongitude,
        ),
      );
    },
    SharedFilesRoute.name: (routeData) {
      final args = routeData.argsAs<SharedFilesRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.SharedFilesScreen(
          key: args.key,
          receiverId: args.receiverId,
        ),
      );
    },
    FestivalRouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.FestivalScreen(),
      );
    },
    ChatListRouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.EmptyRouterPage(),
      );
    },
    LocationRouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.LocationScreen(),
      );
    },
    ProfileRouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.EmptyRouterPage(),
      );
    },
    ChatListRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.ChatListScreen(),
      );
    },
    UserListRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.UserListScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.ProfileScreen(),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i12.EditProfileScreen(
          key: args.key,
          photoUrl: args.photoUrl,
          username: args.username,
          instagram: args.instagram,
          location: args.location,
          age: args.age,
        ),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          HomeRoute.name,
          path: '/',
          children: [
            _i7.RouteConfig(
              FestivalRouter.name,
              path: 'festival',
              parent: HomeRoute.name,
            ),
            _i7.RouteConfig(
              ChatListRouter.name,
              path: 'chatList',
              parent: HomeRoute.name,
              children: [
                _i7.RouteConfig(
                  ChatListRoute.name,
                  path: '',
                  parent: ChatListRouter.name,
                ),
                _i7.RouteConfig(
                  UserListRoute.name,
                  path: 'userList',
                  parent: ChatListRouter.name,
                ),
              ],
            ),
            _i7.RouteConfig(
              LocationRouter.name,
              path: 'location',
              parent: HomeRoute.name,
            ),
            _i7.RouteConfig(
              ProfileRouter.name,
              path: 'profile',
              parent: HomeRoute.name,
              children: [
                _i7.RouteConfig(
                  ProfileRoute.name,
                  path: '',
                  parent: ProfileRouter.name,
                ),
                _i7.RouteConfig(
                  EditProfileRoute.name,
                  path: 'editProfile',
                  parent: ProfileRouter.name,
                ),
              ],
            ),
          ],
        ),
        _i7.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i7.RouteConfig(
          ChatRoute.name,
          path: '/chat',
        ),
        _i7.RouteConfig(
          MapRoute.name,
          path: '/map',
        ),
        _i7.RouteConfig(
          SharedFilesRoute.name,
          path: '/sharedFiles',
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.ChatScreen]
class ChatRoute extends _i7.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    required String username,
    required String userId,
    required String photoUrl,
    required String token,
    _i13.Key? key,
  }) : super(
          ChatRoute.name,
          path: '/chat',
          args: ChatRouteArgs(
            username: username,
            userId: userId,
            photoUrl: photoUrl,
            token: token,
            key: key,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    required this.username,
    required this.userId,
    required this.photoUrl,
    required this.token,
    this.key,
  });

  final String username;

  final String userId;

  final String photoUrl;

  final String token;

  final _i13.Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{username: $username, userId: $userId, photoUrl: $photoUrl, token: $token, key: $key}';
  }
}

/// generated route for
/// [_i4.MapScreen]
class MapRoute extends _i7.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i13.Key? key,
    String? username,
    double? userLatitude,
    double? userLongitude,
  }) : super(
          MapRoute.name,
          path: '/map',
          args: MapRouteArgs(
            key: key,
            username: username,
            userLatitude: userLatitude,
            userLongitude: userLongitude,
          ),
        );

  static const String name = 'MapRoute';
}

class MapRouteArgs {
  const MapRouteArgs({
    this.key,
    this.username,
    this.userLatitude,
    this.userLongitude,
  });

  final _i13.Key? key;

  final String? username;

  final double? userLatitude;

  final double? userLongitude;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, username: $username, userLatitude: $userLatitude, userLongitude: $userLongitude}';
  }
}

/// generated route for
/// [_i5.SharedFilesScreen]
class SharedFilesRoute extends _i7.PageRouteInfo<SharedFilesRouteArgs> {
  SharedFilesRoute({
    _i13.Key? key,
    required String receiverId,
  }) : super(
          SharedFilesRoute.name,
          path: '/sharedFiles',
          args: SharedFilesRouteArgs(
            key: key,
            receiverId: receiverId,
          ),
        );

  static const String name = 'SharedFilesRoute';
}

class SharedFilesRouteArgs {
  const SharedFilesRouteArgs({
    this.key,
    required this.receiverId,
  });

  final _i13.Key? key;

  final String receiverId;

  @override
  String toString() {
    return 'SharedFilesRouteArgs{key: $key, receiverId: $receiverId}';
  }
}

/// generated route for
/// [_i6.FestivalScreen]
class FestivalRouter extends _i7.PageRouteInfo<void> {
  const FestivalRouter()
      : super(
          FestivalRouter.name,
          path: 'festival',
        );

  static const String name = 'FestivalRouter';
}

/// generated route for
/// [_i7.EmptyRouterPage]
class ChatListRouter extends _i7.PageRouteInfo<void> {
  const ChatListRouter({List<_i7.PageRouteInfo>? children})
      : super(
          ChatListRouter.name,
          path: 'chatList',
          initialChildren: children,
        );

  static const String name = 'ChatListRouter';
}

/// generated route for
/// [_i8.LocationScreen]
class LocationRouter extends _i7.PageRouteInfo<void> {
  const LocationRouter()
      : super(
          LocationRouter.name,
          path: 'location',
        );

  static const String name = 'LocationRouter';
}

/// generated route for
/// [_i7.EmptyRouterPage]
class ProfileRouter extends _i7.PageRouteInfo<void> {
  const ProfileRouter({List<_i7.PageRouteInfo>? children})
      : super(
          ProfileRouter.name,
          path: 'profile',
          initialChildren: children,
        );

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i9.ChatListScreen]
class ChatListRoute extends _i7.PageRouteInfo<void> {
  const ChatListRoute()
      : super(
          ChatListRoute.name,
          path: '',
        );

  static const String name = 'ChatListRoute';
}

/// generated route for
/// [_i10.UserListScreen]
class UserListRoute extends _i7.PageRouteInfo<void> {
  const UserListRoute()
      : super(
          UserListRoute.name,
          path: 'userList',
        );

  static const String name = 'UserListRoute';
}

/// generated route for
/// [_i11.ProfileScreen]
class ProfileRoute extends _i7.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i12.EditProfileScreen]
class EditProfileRoute extends _i7.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i13.Key? key,
    required String photoUrl,
    required String username,
    required String instagram,
    required String location,
    required String age,
  }) : super(
          EditProfileRoute.name,
          path: 'editProfile',
          args: EditProfileRouteArgs(
            key: key,
            photoUrl: photoUrl,
            username: username,
            instagram: instagram,
            location: location,
            age: age,
          ),
        );

  static const String name = 'EditProfileRoute';
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({
    this.key,
    required this.photoUrl,
    required this.username,
    required this.instagram,
    required this.location,
    required this.age,
  });

  final _i13.Key? key;

  final String photoUrl;

  final String username;

  final String instagram;

  final String location;

  final String age;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, photoUrl: $photoUrl, username: $username, instagram: $instagram, location: $location, age: $age}';
  }
}
