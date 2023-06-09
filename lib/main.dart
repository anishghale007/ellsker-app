import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/utils/theme_manager.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/features/auth/presentation/cubit/user%20status/user_status_cubit.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/call/presentation/bloc/token/token_bloc.dart';
import 'package:internship_practice/injection_container.dart' as di;
import 'package:internship_practice/routes/router.gr.dart';
import 'features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: Constant.envFileName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "ellsker_app",
        channelName: "ellsker_app",
        channelDescription: "Video Call",
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
        vibrationPattern: highVibrationPattern,
      ),
    ],
  );
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  log("Handling a background message: ${remoteMessage.toString()}");
  log("Background message data: ${remoteMessage.data['name']}");
  log("Background message Time: ${remoteMessage.sentTime}");
  log("Message from: ${remoteMessage.from}");
  log("Message Sender ID: ${remoteMessage.senderId}");
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GoogleSignInBloc>(
          create: (context) => di.sl<GoogleSignInBloc>(),
        ),
        BlocProvider<FacebookSignInBloc>(
          create: (context) => di.sl<FacebookSignInBloc>(),
        ),
        BlocProvider<SignOutCubit>(
          create: (context) => di.sl<SignOutCubit>(),
        ),
        BlocProvider<UserStatusCubit>(
          create: (context) => di.sl<UserStatusCubit>(),
        ),
        BlocProvider<NetworkBloc>(
          create: (context) => di.sl<NetworkBloc>()..add(NetworkObserveEvent()),
        ),
        BlocProvider<TokenBloc>(
          create: (context) => di.sl<TokenBloc>(),
        ),
        BlocProvider<CallBloc>(
          create: (context) => di.sl<CallBloc>(),
        )
      ],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: _appRouter.delegate(
              initialRoutes: snapshot.data == null
                  ? [const LoginRoute()]
                  : [const HomeRoute()],
            ),
            // routerDelegate: AutoRouterDelegate.declarative(
            //   _appRouter,
            //   routes: (_) => [
            //     if (snapshot.data == null)
            //       const LoginRoute()
            //     else
            //       const HomeRoute()
            //   ],
            // ),
            routeInformationParser: _appRouter.defaultRouteParser(),
            theme: getApplicationTheme(),
          );
        },
      ),
    );
  }
}
