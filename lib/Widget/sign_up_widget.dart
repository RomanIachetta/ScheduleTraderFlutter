import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shiftit/Widget/register_email_pass.dart';
import 'package:shiftit/page/login_page.dart';
import 'package:shiftit/provider/google_sign_in.dart';
import 'package:shiftit/utils/constants.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const FlutterLogo(size: 120),
          const Spacer(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hey There,\nWelcome Back',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login to your account to continue',
              style: TextStyle(
                  fontSize: 14, decoration: TextDecoration.none, color: color),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterWithEmailAndPass()));
            },
            label: const Text('Register'),
            icon: const FaIcon(FontAwesomeIcons.envelope),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
            label: const Text('Sign Up with Google'),
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.googleLogin();

              final auth = FirebaseAuth.instance;

              var convertedUser =
                  await FirebaseFunctions.convertFirebaseUserToMyUser(
                      auth.currentUser!, '');

              UserPreferences.myUser = convertedUser;
              int i = 0;
              for (var element in Constants.productionList) {
                if (i == 4) {
                  break;
                }
                convertedUser.jobs.add(element);
              }
              FirebaseFunctions.addUserToDb(convertedUser);
            },
          ),
          const SizedBox(height: 40),
          RichText(
            text: TextSpan(
              text: 'Already have an account?',
              style: TextStyle(color: color),
              children: [
                TextSpan(
                  text: 'Log in',
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// final isDarkMode = Theme.of(context).brightness == Brightness.dark;
