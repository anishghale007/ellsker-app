import 'package:flutter/material.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3A4070),
              Color(0xff1F1F40),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(),
          ),
        ),
      ),
    );
  }
}
