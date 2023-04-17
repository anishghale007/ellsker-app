import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list_cubit.dart';
import 'package:internship_practice/injection_container.dart' as di;
import 'package:internship_practice/router.dart';
import 'package:internship_practice/ui_pages.dart';
import 'features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        BlocProvider<UserListCubit>(
          create: (_) => di.sl<UserListCubit>()..getAllUsers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routers.generateRoute,
        initialRoute: kLoginScreenPath,
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
      ),
    );
  }
}
