import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_boddy/screens/signup_screen.dart';
import 'package:tree_boddy/utils/colors.dart';
import 'package:tree_boddy/widgets/text_field_input.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
        (route) => false,
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void navigateToSingup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //svg image
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: menuBarBackgroundColor,
              height: 64,
            ),
            const SizedBox(height: 64),
            //text field input for email
            TextFieldInput(
              hinText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),

            const SizedBox(
              height: 24,
            ),
            //text field imput for password
            TextFieldInput(
              hinText: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(
              height: 24,
            ),
            //button login

            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: menuBarBackgroundColor,
                ),
                child: !_isLoading
                    ? const Text(
                        'Log in',
                      )
                    : const CircularProgressIndicator(
                        color: primaryColor,
                      ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //transitioning for sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: navigateToSingup,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Create new account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: menuBarBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
