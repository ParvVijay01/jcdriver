import 'package:flutter/material.dart';
import 'package:jcdriver/components/textfields/signin_textfield.dart';
import 'package:jcdriver/data/providers/driver_provider.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/images.dart';
import 'package:jcdriver/utilities/constants/sizes.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<DriverProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.topCenter,
            constraints: const BoxConstraints(maxWidth: IKSizes.container),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(150)),
                        child: Image.asset(
                          IKImages.logo,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 25),
                    constraints:
                        const BoxConstraints(maxWidth: IKSizes.container),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign In To Your Account',
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Welcome Back! You've Been Missed!",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.color,
                                  fontSize: 15),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 15),
                        SigninTextfield(
                          labelText: "Username",
                          controller: usernameController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 15),
                        SigninTextfield(
                          labelText: "Password",
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () async {
                            bool success = await userProvider.loginRider(
                              usernameController.text,
                              passwordController.text,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Login Successful!"),
                                  backgroundColor: IKColors.success,
                                ),
                              );
                              Navigator.pushNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(userProvider.errorMessage ??
                                      "Login failed"),
                                  backgroundColor: IKColors.danger,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: IKColors.primary,
                            side: const BorderSide(color: IKColors.secondary),
                            foregroundColor: Theme.of(context).cardColor,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Sign in'),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
