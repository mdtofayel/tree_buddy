import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_boddy/responsive/mobile_screen_layout.dart';
import 'package:tree_boddy/responsive/responsive_layout_screen.dart';
import 'package:tree_boddy/responsive/web_screen_layout.dart';
import 'package:tree_boddy/screens/login_screen.dart';

import 'package:tree_boddy/screens/signup_screen.dart';
import 'package:tree_boddy/utils/colors.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyALrELN4r7UTVlRNg1wwmObPYDzTkVIwFE',
          appId: '1:101145274119:web:091f9c3608c4d9c585c7a2',
          messagingSenderId: '101145274119',
          projectId: 'tree-buddies',
          storageBucket: 'tree-buddies.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tree Buddies',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: treBuddiesBackgroundColor,
        ),
        // home: const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
