import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_practice/common/widgets/login_button_widget.dart';
import 'package:internship_practice/features/auth/presentation/pages/bottom_nav_bar_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                LoginButtonWidget(
                  buttonText: "Continue with Instagram",
                  buttonIcon: FontAwesomeIcons.instagram,
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBarScreen()),
                    );
                  },
                ),
                LoginButtonWidget(
                  buttonText: "Continue with Facebook",
                  buttonIcon: FontAwesomeIcons.facebook,
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBarScreen()),
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
