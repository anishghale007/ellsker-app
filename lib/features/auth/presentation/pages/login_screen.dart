import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_practice/common/loading_overlay/loading_overlay.dart';
import 'package:internship_practice/features/auth/presentation/widgets/login_button_widget.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/utils/assets_manager.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/auth/presentation/pages/bottom_nav_bar_screen.dart';
import 'package:internship_practice/features/auth/presentation/widgets/login_logo_widget.dart';
import '../bloc/facebook_sign_in/facebook_sign_in_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.loginBackground),
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.srcOver,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: MultiBlocListener(
              listeners: [
                BlocListener<NetworkBloc, NetworkState>(
                  listener: (context, state) {
                    if (state is NetworkFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 10),
                          content: Text(Constant.networkFailureMessage),
                        ),
                      );
                    } else if (state is NetworkSuccess) {
                      log("Connected to Internet");
                    }
                  },
                ),
              ],
              child: Column(
                children: [
                  const LoginLogoWidget(),
                  const SizedBox(
                    height: 200,
                  ),
                  BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
                    listener: (context, state) {
                      if (state is GoogleSignInSuccess) {
                        _loadingOverlay.hide();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBarScreen()),
                        );
                      } else if (state is GoogleSignInFailure) {
                        _loadingOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage.toString()),
                        ));
                      } else if (state is GoogleSignInLoading) {
                        _loadingOverlay.show(context);
                      }
                    },
                    builder: (context, state) {
                      return LoginButtonWidget(
                        buttonText: AppStrings.continueWithGoogle,
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
                        _loadingOverlay.hide();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBarScreen()),
                        );
                      } else if (state is FacebookSignInFailure) {
                        _loadingOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage.toString()),
                        ));
                      } else if (state is FacebookSignInLoading) {
                        _loadingOverlay.show(context);
                      }
                    },
                    builder: (context, state) {
                      return LoginButtonWidget(
                        buttonText: AppStrings.continueWithFacebook,
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
