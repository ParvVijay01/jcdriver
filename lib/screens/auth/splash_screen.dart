import 'dart:async';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/images.dart';
import 'package:jcdriver/utilities/constants/sizes.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void setupWorldTime() async {
    Timer(const Duration(seconds: 1),
        () => Navigator.pushReplacementNamed(context, "/onboarding"));
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IKColors.card,
      body: Center(
          child: Container(
        constraints: const BoxConstraints(
          maxWidth: IKSizes.container,
        ),
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IKImages.splash),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('VERSION 1.0',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.merge(const TextStyle(color: IKColors.secondary))),
            ),
          ],
        ),
      )),
    );
  }
}
