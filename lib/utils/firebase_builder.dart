import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFirebaseTable extends StatefulWidget {
  final String table;
  const GetFirebaseTable({Key? key, required this.table}) : super(key: key);

  @override
  _GetFirebaseTableState createState() => _GetFirebaseTableState();
}

class _GetFirebaseTableState extends State<GetFirebaseTable> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.table).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          return ListView(
            children: snapshot.data!.docs.map((item){
              return Center(
                child: ListTile(
                  title: Text(item['name']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
