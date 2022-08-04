import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shiftit/Widget/logged_in_widget.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email, _pass;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: "Password"),
            onChanged: (value) {
              setState(() {
                _pass = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                auth.signInWithEmailAndPassword(email: _email, password: _pass);
                UserPreferences.myUser =
                    await FirebaseFunctions.convertFirebaseUserToMyUser(
                        auth.currentUser!, '');
                //Navigator.pop(context);

              } catch (exception) {
                print(exception);
              }

              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoggedInWidget()));
            },
            child: const Text('Sign In'),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
