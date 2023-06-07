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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i16;

import '../features/auth/presentation/pages/festival_screen.dart' as _i11;
import '../features/auth/presentation/pages/home_screen.dart' as _i2;
import '../features/auth/presentation/pages/login_screen.dart' as _i1;
import '../features/call/presentation/pages/call_history_screen.dart' as _i7;
import '../features/call/presentation/pages/incoming_call_screen.dart' as _i8;
import '../features/call/presentation/pages/video_call_screen.dart' as _i6;
import '../features/chat/presentation/pages/chat_list_screen.dart' as _i12;
import '../features/chat/presentation/pages/chat_screen.dart' as _i3;
import '../features/chat/presentation/pages/media_files_screen.dart' as _i5;
import '../features/chat/presentation/pages/user_list_screen.dart' as _i13;
import '../features/location/presentation/pages/location_screen.dart' as _i10;
import '../features/location/presentation/pages/map_screen.dart' as _i4;
import '../features/profile/presentation/pages/edit_profile_screen.dart'
    as _i15;
import '../features/profile/presentation/pages/profile_screen.dart' as _i14;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i16.GlobalKey<_i16.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.LoginScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
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
      return _i9.MaterialPageX<dynamic>(
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
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.SharedFilesScreen(
          key: args.key,
          receiverId: args.receiverId,
        ),
      );
    },
    VideoCallRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.VideoCallScreen(),
      );
    },
    CallHistoryRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.CallHistoryScreen(),
      );
    },
    IncomingCallRoute.name: (routeData) {
      final args = routeData.argsAs<IncomingCallRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.IncomingCallScreen(
          key: args.key,
          scaffold: args.scaffold,
        ),
      );
    },
    FestivalRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    ChatListRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    LocationRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.LocationScreen(),
      );
    },
    ProfileRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.EmptyRouterPage(),
      );
    },
    FestivalRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.FestivalScreen(),
      );
    },
    ChatListRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.ChatListScreen(),
      );
    },
    UserListRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i13.UserListScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.ProfileScreen(),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.EditProfileScreen(
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
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          LoginRoute.name,
          path: '/login',
          children: [
            _i9.RouteConfig(
              '*#redirect',
              path: '*',
              parent: LoginRoute.name,
              redirectTo: '',
              fullMatch: true,
            )
          ],
        ),
        _i9.RouteConfig(
          HomeRoute.name,
          path: '/',
          children: [
            _i9.RouteConfig(
              FestivalRouter.name,
              path: 'festival',
              parent: HomeRoute.name,
              children: [
                _i9.RouteConfig(
                  FestivalRoute.name,
                  path: '',
                  parent: FestivalRouter.name,
                )
              ],
            ),
            _i9.RouteConfig(
              ChatListRouter.name,
              path: 'chatList',
              parent: HomeRoute.name,
              children: [
                _i9.RouteConfig(
                  ChatListRoute.name,
                  path: '',
                  parent: ChatListRouter.name,
                ),
                _i9.RouteConfig(
                  UserListRoute.name,
                  path: 'userList',
                  parent: ChatListRouter.name,
                ),
              ],
            ),
            _i9.RouteConfig(
              LocationRouter.name,
              path: 'location',
              parent: HomeRoute.name,
            ),
            _i9.RouteConfig(
              ProfileRouter.name,
              path: 'profile',
              parent: HomeRoute.name,
              children: [
                _i9.RouteConfig(
                  ProfileRoute.name,
                  path: '',
                  parent: ProfileRouter.name,
                ),
                _i9.RouteConfig(
                  EditProfileRoute.name,
                  path: 'editProfile',
                  parent: ProfileRouter.name,
                ),
              ],
            ),
          ],
        ),
        _i9.RouteConfig(
          ChatRoute.name,
          path: '/chat',
        ),
        _i9.RouteConfig(
          MapRoute.name,
          path: '/map',
        ),
        _i9.RouteConfig(
          SharedFilesRoute.name,
          path: '/sharedFiles',
        ),
        _i9.RouteConfig(
          VideoCallRoute.name,
          path: '/videoCall',
        ),
        _i9.RouteConfig(
          CallHistoryRoute.name,
          path: '/callHistory',
        ),
        _i9.RouteConfig(
          IncomingCallRoute.name,
          path: '/incomingCall',
        ),
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          path: '/login',
          initialChildren: children,
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.ChatScreen]
class ChatRoute extends _i9.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    required String username,
    required String userId,
    required String photoUrl,
    required String token,
    _i16.Key? key,
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

  final _i16.Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{username: $username, userId: $userId, photoUrl: $photoUrl, token: $token, key: $key}';
  }
}

/// generated route for
/// [_i4.MapScreen]
class MapRoute extends _i9.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

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
class SharedFilesRoute extends _i9.PageRouteInfo<SharedFilesRouteArgs> {
  SharedFilesRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

  final String receiverId;

  @override
  String toString() {
    return 'SharedFilesRouteArgs{key: $key, receiverId: $receiverId}';
  }
}

/// generated route for
/// [_i6.VideoCallScreen]
class VideoCallRoute extends _i9.PageRouteInfo<void> {
  const VideoCallRoute()
      : super(
          VideoCallRoute.name,
          path: '/videoCall',
        );

  static const String name = 'VideoCallRoute';
}

/// generated route for
/// [_i7.CallHistoryScreen]
class CallHistoryRoute extends _i9.PageRouteInfo<void> {
  const CallHistoryRoute()
      : super(
          CallHistoryRoute.name,
          path: '/callHistory',
        );

  static const String name = 'CallHistoryRoute';
}

/// generated route for
/// [_i8.IncomingCallScreen]
class IncomingCallRoute extends _i9.PageRouteInfo<IncomingCallRouteArgs> {
  IncomingCallRoute({
    _i16.Key? key,
    required _i16.Widget scaffold,
  }) : super(
          IncomingCallRoute.name,
          path: '/incomingCall',
          args: IncomingCallRouteArgs(
            key: key,
            scaffold: scaffold,
          ),
        );

  static const String name = 'IncomingCallRoute';
}

class IncomingCallRouteArgs {
  const IncomingCallRouteArgs({
    this.key,
    required this.scaffold,
  });

  final _i16.Key? key;

  final _i16.Widget scaffold;

  @override
  String toString() {
    return 'IncomingCallRouteArgs{key: $key, scaffold: $scaffold}';
  }
}

/// generated route for
/// [_i9.EmptyRouterPage]
class FestivalRouter extends _i9.PageRouteInfo<void> {
  const FestivalRouter({List<_i9.PageRouteInfo>? children})
      : super(
          FestivalRouter.name,
          path: 'festival',
          initialChildren: children,
        );

  static const String name = 'FestivalRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class ChatListRouter extends _i9.PageRouteInfo<void> {
  const ChatListRouter({List<_i9.PageRouteInfo>? children})
      : super(
          ChatListRouter.name,
          path: 'chatList',
          initialChildren: children,
        );

  static const String name = 'ChatListRouter';
}

/// generated route for
/// [_i10.LocationScreen]
class LocationRouter extends _i9.PageRouteInfo<void> {
  const LocationRouter()
      : super(
          LocationRouter.name,
          path: 'location',
        );

  static const String name = 'LocationRouter';
}

/// generated route for
/// [_i9.EmptyRouterPage]
class ProfileRouter extends _i9.PageRouteInfo<void> {
  const ProfileRouter({List<_i9.PageRouteInfo>? children})
      : super(
          ProfileRouter.name,
          path: 'profile',
          initialChildren: children,
        );

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i11.FestivalScreen]
class FestivalRoute extends _i9.PageRouteInfo<void> {
  const FestivalRoute()
      : super(
          FestivalRoute.name,
          path: '',
        );

  static const String name = 'FestivalRoute';
}

/// generated route for
/// [_i12.ChatListScreen]
class ChatListRoute extends _i9.PageRouteInfo<void> {
  const ChatListRoute()
      : super(
          ChatListRoute.name,
          path: '',
        );

  static const String name = 'ChatListRoute';
}

/// generated route for
/// [_i13.UserListScreen]
class UserListRoute extends _i9.PageRouteInfo<void> {
  const UserListRoute()
      : super(
          UserListRoute.name,
          path: 'userList',
        );

  static const String name = 'UserListRoute';
}

/// generated route for
/// [_i14.ProfileScreen]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i15.EditProfileScreen]
class EditProfileRoute extends _i9.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i16.Key? key,
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

  final _i16.Key? key;

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
