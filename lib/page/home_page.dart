import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiftit/Widget/logged_in_widget.dart';
import 'package:shiftit/Widget/sign_up_widget.dart';
import 'package:shiftit/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = '';
  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/jobs/production.txt');
  }

  Future<List<String>> loadProductionList() async {
    List<String> productionList = [];
    await rootBundle.loadString('assets/jobs/production.txt').then((q) {
      for (String i in const LineSplitter().convert(q)) {
        productionList.add(i);
      }
    });
    return productionList;
  }

  _setup() async {
    // Retrieve the questions (Processed in the background)
    List<String> questions = await loadProductionList();

    // Notify the UI and display the questions
    Constants.productionList = questions;
  }

  @override
  void initState() {
    // TODO: implement initState
    _setup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              return LoggedInWidget();
            } else {
              return const SignUpWidget();
            }
          },
        ),
      );
}
