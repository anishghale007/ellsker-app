import 'package:auto_route/auto_route.dart';
import 'package:internship_practice/features/auth/presentation/pages/festival_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/home_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/login_screen.dart';
import 'package:internship_practice/features/call/presentation/pages/call_history_screen.dart';
import 'package:internship_practice/features/call/presentation/pages/incoming_call_screen.dart';
import 'package:internship_practice/features/call/presentation/pages/video_call_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/media_files_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/user_list_screen.dart';
import 'package:internship_practice/features/location/presentation/pages/location_screen.dart';
import 'package:internship_practice/features/location/presentation/pages/map_screen.dart';
import 'package:internship_practice/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:internship_practice/features/profile/presentation/pages/profile_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    // Authentication Routing
    AutoRoute(
      path: '/login',
      initial: true,
      page: LoginScreen,
      children: [
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    // Bottom Nav Bar Nested Routing
    AutoRoute(
      path: '/',
      page: HomeScreen,
      children: [
        AutoRoute(
          path: 'festival',
          name: 'FestivalRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: FestivalScreen,
            ),
          ],
        ),
        AutoRoute(
          path: 'chatList',
          name: 'ChatListRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: ChatListScreen,
            ),
            AutoRoute(
              path: 'userList',
              page: UserListScreen,
            ),
          ],
        ),
        AutoRoute(
          path: 'location',
          name: 'LocationRouter',
          page: LocationScreen,
        ),
        AutoRoute(
          path: 'profile',
          name: 'ProfileRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: ProfileScreen,
            ),
            AutoRoute(
              path: 'editProfile',
              page: EditProfileScreen,
            ),
          ],
        ),
      ],
    ),
    // Non-nested Routing

    AutoRoute(
      path: '/chat',
      page: ChatScreen,
    ),
    AutoRoute(
      path: '/map',
      page: MapScreen,
    ),
    AutoRoute(
      path: '/sharedFiles',
      page: SharedFilesScreen,
    ),
    AutoRoute(
      path: '/videoCall',
      page: VideoCallScreen,
    ),
    AutoRoute(
      path: '/callHistory',
      page: CallHistoryScreen,
    ),
    AutoRoute(
      path: '/incomingCall',
      page: IncomingCallScreen,
    ),
  ],
)
class $AppRouter {}
