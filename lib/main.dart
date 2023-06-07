import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/features/auth/presentation/cubit/user%20status/user_status_cubit.dart';
import 'package:internship_practice/features/call/presentation/bloc/token_bloc.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:internship_practice/injection_container.dart' as di;
import 'package:internship_practice/routes/router.gr.dart';
import 'features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'features/notification/presentation/bloc/notification/notification_bloc.dart';
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
        BlocProvider<ConversationCubit>(
          create: (context) => di.sl<ConversationCubit>(),
        ),
        BlocProvider<ConversationBloc>(
          create: (context) => di.sl<ConversationBloc>(),
        ),
        BlocProvider<MessageCubit>(
          create: (context) => di.sl<MessageCubit>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => di.sl<NotificationBloc>(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => di.sl<NotificationCubit>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),
        BlocProvider<NetworkBloc>(
          create: (context) => di.sl<NetworkBloc>()..add(NetworkObserveEvent()),
        ),
        BlocProvider<TokenBloc>(
          create: (context) => di.sl<TokenBloc>(),
        ),
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
            theme: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                hintStyle: GoogleFonts.sourceSansPro(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: ColorUtil.kTextFieldColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
