import 'package:flutter/material.dart';
import 'package:shiftit/Widget/select_shift_widget.dart';
import 'package:shiftit/model/event.dart';
import 'package:shiftit/model/shift.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';

class ShiftListWidget extends StatefulWidget {
  final List<Event> eventList;
  final DateTime selectedDay;
  final Function refresh;
  const ShiftListWidget(
      {Key? key,
      required this.eventList,
      required this.selectedDay,
      required this.refresh})
      : super(key: key);

  @override
  _ShiftListWidgetState createState() => _ShiftListWidgetState();
}

class _ShiftListWidgetState extends State<ShiftListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.eventList.length,
        itemBuilder: (context, position) {
          return ListTile(
            title: Text(widget.eventList[position].title),
            onTap: () {
              if (widget.eventList[position].fullName ==
                  UserPreferences.myUser!.uid) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Remove Shift"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            var selectedEvent = widget.eventList[position];
                            await FirebaseFunctions.removeShiftFromDb(
                                selectedEvent.shiftId);
                            widget.refresh();
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
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Selected Shift"),
                    content: SelectShiftWidget(
                      selectedDay: widget.selectedDay,
                      event: widget.eventList[position],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            var selectedEvent = widget.eventList[position];
                            var shift = Shift(
                                date: widget.selectedDay,
                                start: selectedEvent.startTime,
                                end: selectedEvent.endTime,
                                user: selectedEvent.fullName,
                                wanted: true,
                                approval: false,
                                job: selectedEvent.job,
                                wantedUser: UserPreferences.myUser!.uid);
                            await FirebaseFunctions.addWantedShiftsToDb(shift);
                            //REMOVE SHIFT NOW
                            await FirebaseFunctions.updateShift(
                                shift, widget.eventList[position].shiftId);
                            widget.refresh();
                            // FirebaseFunctions.removeShiftFromDb(
                            //     widget.eventList[position].shiftId);
                            Navigator.pop(context, "Ok");
                          },
                          child: const Text("Get Shift")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, "Cancel");
                          },
                          child: const Text("Cancel")),
                    ],
                  ),
                );
              }
            }, // Handle your onTap here.
          );
        },
      ),
    );
    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: 2,
    //     itemBuilder: (context, position) {
    //       return Card(
    //         child: Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text("e.g., those that are not Expanded"),
    //         ),
    //       );
    //     },
    //   ),
    // );

    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: widget.eventList.length,
    //     itemBuilder: (_, index) {
    //       return ListTile(
    //         title: Text(widget.eventList[index].title),
    //         onTap: () {}, // Handle your onTap here.
    //       );
    //     },
    //   ),
    // );
  }
}
