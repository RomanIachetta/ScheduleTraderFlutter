import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shiftit/Widget/tree_view_widget.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/utils/constants.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

import 'logged_in_widget.dart';

class RegisterWithEmailAndPass extends StatefulWidget {
  const RegisterWithEmailAndPass({Key? key}) : super(key: key);

  @override
  _RegisterWithEmailAndPassState createState() =>
      _RegisterWithEmailAndPassState();
}

class _RegisterWithEmailAndPassState extends State<RegisterWithEmailAndPass> {
  late List<String> _selectedJobs = Constants.productionList;

  void parentChange(newList) {
    setState(() {
      _selectedJobs = newList;
    });
  }

  late String _email, _pass, _name;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Register For Shift It'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(hintText: "Name"),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
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
                decoration: const InputDecoration(hintText: "Password"),
                onChanged: (value) {
                  setState(() {
                    _pass = value;
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TreeViewWidget(
                shownItems: Constants.productionList,
                selectedItems: _selectedJobs,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await auth.createUserWithEmailAndPassword(
                        email: _email, password: _pass);

                    var convertedUser =
                        await FirebaseFunctions.convertFirebaseUserToMyUser(
                            auth.currentUser!, _name);

                    convertedUser.name = _name;
                    convertedUser.jobs = _selectedJobs;
                    UserPreferences.myUser = convertedUser;

                    FirebaseFunctions.addUserToDb(convertedUser);

                    await auth.signInWithEmailAndPassword(
                        email: _email, password: _pass);

                    Navigator.pop(context, this);
                  } catch (ex) {
                    print(ex);
                  }
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoggedInWidget()));
                },
                child: const Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
