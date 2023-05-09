import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_practice/common/loading_overlay/loading_overlay.dart';
import 'package:internship_practice/common/widgets/login_button_widget.dart';
import 'package:internship_practice/core/utils/assets_manager.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/pages/bottom_nav_bar_screen.dart';
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
                          image: AssetImage(ImageAssets.logo),
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
                      image: AssetImage(ImageAssets.ellsker),
                    ),
                  ),
                ),
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
                        context.read<GoogleSignInBloc>().add(GoogleUserEvent());
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
    );
  }
}
