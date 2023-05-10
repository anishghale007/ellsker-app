import 'package:flutter/material.dart';
import 'package:internship_practice/core/utils/assets_manager.dart';

class LoginLogoWidget extends StatelessWidget {
  const LoginLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
