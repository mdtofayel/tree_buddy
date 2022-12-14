import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_boddy/resources/auth_methods.dart';
import 'package:tree_boddy/screens/login_screen.dart';
import 'package:tree_boddy/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      //_image = im;
    });
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userNameController.text,
      bio: _bioController.text,
      //file: _image!,
    );

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
        (route) => false,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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
              flex: 1,
              child: Container(),
            ),
            //svg image
            SvgPicture.asset(
              'assets/ic_iagram.svg',
              color: menuBarBackgroundColor,
              height: 40,
            ),
            const SizedBox(height: 10),
            //text field for username
            //circular widget to accept and show out selected file
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: menuBarBackgroundColor,
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: Color.fromARGB(255, 54, 244, 89),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: menuBarBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldInput(
              hinText: 'Enter your username',
              textInputType: TextInputType.text,
              textEditingController: _userNameController,
            ),

            const SizedBox(
              height: 10,
            ),

            //text field input for email
            TextFieldInput(
              hinText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),

            const SizedBox(
              height: 10,
            ),
            //text field imput for password
            TextFieldInput(
              hinText: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(
              height: 10,
            ),

            TextFieldInput(
              hinText: 'Enter your Bio',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),

            const SizedBox(
              height: 10,
            ),
            //button login

            InkWell(
              onTap: signUpUser,
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: buttomBackgroundColorAfterSubmit,
                        ),
                      )
                    : const Text('Sign up'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            //  transitioning for sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: menuBarBackgroundColor),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
