import 'package:flutter/material.dart';
import 'package:shiftit/model/event.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class MyShifts extends StatefulWidget {
  const MyShifts({Key? key}) : super(key: key);

  @override
  _MyShiftsState createState() => _MyShiftsState();
}

class _MyShiftsState extends State<MyShifts> {
  late List<Event> events = [];
  @override
  void initState() {
    // TODO: implement initState

    getShifts();
    super.initState();
  }

  void getShifts() async {
    events = await FirebaseFunctions.getUsersShiftsFromDb(
        UserPreferences.myUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shifts'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(events[index].title),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Remove Shift"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            var selectedEvent = events[index];
                            await FirebaseFunctions.removeShiftFromDb(
                                selectedEvent.shiftId);
                            events.remove(events[index]);
                            setState(() {});
                            Navigator.pop(context, "Ok");
                          },
                          child: const Text("Remove Shift?")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, "Cancel");
                          },
                          child: const Text("Cancel")),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
