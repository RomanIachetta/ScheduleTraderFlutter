import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shiftit/Widget/appbar_widget.dart';
import 'package:shiftit/Widget/profile_widget.dart';
import 'package:shiftit/Widget/textfield_widget.dart';
import 'package:shiftit/Widget/tree_view_edit_profile_widget.dart';
import 'package:shiftit/Widget/tree_view_widget.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/themes.dart';
import 'package:shiftit/utils/constants.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  MyUser user = UserPreferences.myUser ??
      FirebaseFunctions.getUserFromDb(UserPreferences.auth.currentUser!.uid);

  String name = '';
  String email = '';
  String work = '';
  List<String> selectedJobs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
              imagePath: user.imagePath, isEdit: true, onClicked: () {}),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChanged: (name) {
              this.name = name;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (email) {
              this.email = email;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Work',
            text: user.work,
            onChanged: (work) {
              //UserPreferences.myUser.work = work;
              this.work = work;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          TreeViewEditProfileWidget(
            shownItems: Constants.productionList,
            selectedItems: selectedJobs,
            usersJobs: user.jobs,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyThemes.primary,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {
          bool changed = false;
          if (name != "" && user.name != name) {
            user.name = name;
            changed = true;
          }
          if (email != "" && user.email != email) {
            user.email = email;
            changed = true;
          }
          if (work != "" && user.work != work) {
            user.work = work;
            changed = true;
          }
          if (selectedJobs != user.jobs) {
            user.jobs = selectedJobs;
            changed = true;
          }
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          user.isDarkMode = isDarkMode;
          if (changed) {
            FirebaseFunctions.updateUser(user);
          }
        },
      ),
    );
  }
}
