import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/page/home_page.dart';
import 'package:shiftit/provider/google_sign_in.dart';
import 'package:shiftit/themes.dart';
import 'package:shiftit/utils/user_preferences.dart';

import 'Widget/sign_up_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'MainPage';

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: ThemeProvider(
          initTheme: MyThemes.darkTheme,

          //initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
          child: Builder(
            builder: (context) => MaterialApp(
              home: const HomePage(),
              debugShowCheckedModeBanner: true,
              theme: MyThemes.darkTheme,
              title: title,
            ),
          ),
        ),
      );
}
