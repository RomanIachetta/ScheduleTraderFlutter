import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shiftit/Widget/profile_widget.dart';
import 'package:shiftit/Widget/tree_view_widget.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/page/edit_profile_page.dart';
import 'package:shiftit/page/my_shift_page.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final textController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  static final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //final MyUser user = UserPreferences.myUser;
    final MyUser user = UserPreferences.myUser ??
        FirebaseFunctions.getUserFromDb(UserPreferences.auth.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const MyShifts()))
                    .then((value) => setState(() {}));
              },
              child: const Text('My Shifts',
                  style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Column(
        children: [
          ProfileWidget(
            imagePath: auth.currentUser!.photoURL ??
                'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
            onClicked: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const EditProfilePage()));
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const EditProfilePage()))
                  .then((value) => setState(() {}));
            },
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(user),
          const SizedBox(
            height: 24,
          ),
          const Text(
            "Selected Wanted Jobs",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: user.jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Center(child: Text('Entry ${user.jobs[index]}')),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buildName(MyUser user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.work,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
}

class UserList extends StatefulWidget {
  final CollectionReference users;

  const UserList({Key? key, required this.users}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.users.orderBy('name').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading'));
          }
          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((user) {
              return Center(
                child: ListTile(
                  title: Text(user['name']),
                  onLongPress: () {
                    user.reference.delete();
                  },
                ),
              );
            }).toList(),
          );
        });
  }
}
//
// class _UserListState extends State<UserList> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: StreamBuilder(
//           stream: widget.users.orderBy('name').snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: Text('Loading'));
//             }
//             return ListView(
//               children: snapshot.data!.docs.map((user) {
//                 return Center(
//                   child: ListTile(
//                     title: Text(user['name']),
//                     onLongPress: () {
//                       user.reference.delete();
//                     },
//                   ),
//                 );
//               }).toList(),
//             );
//           }),
//     );
//   }
// }
