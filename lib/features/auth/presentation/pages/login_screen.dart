import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_practice/common/widgets/login_button_widget.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/pages/bottom_nav_bar_screen.dart';

import '../../../../injection_container.dart';
import '../bloc/facebook_sign_in_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late GoogleSignInBloc _bloc;

  // @override
  // void initState() {
  //   _bloc = sl<GoogleSignInBloc>();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _bloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_background.png"),
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.srcOver,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GoogleSignInBloc>(
            create: (context) => sl<GoogleSignInBloc>(),
          ),
          BlocProvider<FacebookSignInBloc>(
            create: (context) => sl<FacebookSignInBloc>(),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 100,
                        bottom: 20,
                      ),
                      child: Container(
                        height: 230,
                        width: 230,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/ellsker.png"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
                    listener: (context, state) {
                      if (state is GoogleSignInSuccess) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBarScreen()),
                        );
                      } else if (state is GoogleSignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage.toString()),
                        ));
                      }
                    },
                    builder: (context, state) {
                      return LoginButtonWidget(
                        buttonText: "Continue with Google",
                        buttonIcon: FontAwesomeIcons.google,
                        onPress: () {
                          context
                              .read<GoogleSignInBloc>()
                              .add(GoogleUserEvent());
                        },
                      );
                    },
                  ),
                  BlocConsumer<FacebookSignInBloc, FacebookSignInState>(
                    listener: (context, state) {
                      if (state is FacebookSignInSuccess) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBarScreen()),
                        );
                      } else if (state is FacebookSignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage.toString()),
                        ));
                      }
                    },
                    builder: (context, state) {
                      return LoginButtonWidget(
                        buttonText: "Continue with Facebook",
                        buttonIcon: FontAwesomeIcons.facebook,
                        onPress: () {
                          context
                              .read<FacebookSignInBloc>()
                              .add(FacebookUserEvent());
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
