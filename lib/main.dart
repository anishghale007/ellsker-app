import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:internship_practice/injection_container.dart' as di;
import 'package:internship_practice/router.dart';
import 'package:internship_practice/ui_pages.dart';
import 'features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'features/notification/presentation/bloc/notification/notification_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
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
  const MyApp({super.key});

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
        BlocProvider<ConversationCubit>(
          create: (context) =>
              di.sl<ConversationCubit>()..getAllConversations(),
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
        )
      ],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routers.generateRoute,
            initialRoute:
                snapshot.data == null ? kLoginScreenPath : kBottomNavBarPath,
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
