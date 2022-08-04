import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shiftit/Widget/shift_list_widget.dart';
import 'package:shiftit/model/event.dart';
import 'package:shiftit/model/my_user.dart';
import 'package:shiftit/model/shift.dart';
import 'package:shiftit/page/profile_page.dart';
import 'package:shiftit/page/shift_details_page.dart';
import 'package:shiftit/provider/google_sign_in.dart';
import 'package:shiftit/utils/firebase_functions.dart';
import 'package:shiftit/utils/user_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../themes.dart';
import 'add_shift_widget.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  late Map<DateTime, List<Event>> selectedEvents;

  final TextEditingController _eventController = TextEditingController();

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  void getFirebaseShifts() async {
    Map shifts = await FirebaseFunctions.getNestleShiftsFromDb();
    selectedEvents.clear();
    for (final element in shifts.entries) {
      if (element.value["date"] == null) {
        continue;
      }
      if (element.value["wanted"] == true) {
        continue;
      }
      var dateTimeDate =
          DateTime.parse(element.value["date"].toDate().toString());
      var date = DateUtils.dateOnly(dateTimeDate);
      if (date.compareTo(DateTime.now()) < 0) {
        continue;
      }
      var strDate = date.toString() + "Z";

      date = DateTime.parse(strDate);

      var start = element.value["start"];
      var end = element.value["end"];
      var timeDayStart = stringToTimeOfDay(start);
      var timeDayEnd = stringToTimeOfDay(end);
      if (selectedEvents[date] != null) {
        selectedEvents[date]!.add(Event(
            title:
                'Start Time:${element.value["start"]}\nEnd Time ${element.value["end"]}\nJob:${element.value["job"]}',
            endTime: timeDayEnd,
            startTime: timeDayStart,
            job: element.value["job"],
            fullName: element.value["user"],
            shiftId: element.key));
        // fullName: await FirebaseFunctions.getFullNameFromUserUid(
        //     element.value["user"]),
      } else {
        selectedEvents[date] = [
          Event(
              title:
                  'Start Time:${element.value["start"]}\nEnd Time ${element.value["end"]}\nJob:${element.value["job"]}',
              startTime: timeDayStart,
              endTime: timeDayEnd,
              job: element.value["job"],
              fullName: element.value["user"],
              shiftId: element.key)
        ];
      }
    }
    _eventController.clear();
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    selectedEvents = {};
    _selectedDay = _focusedDay;
    getFirebaseShifts();
    super.initState();
  }

  late TimeOfDay startDate = const TimeOfDay(hour: 7, minute: 15);
  late TimeOfDay endDate = const TimeOfDay(hour: 7, minute: 15);
  late String dropValue = UserPreferences.myUser!.jobs.first;
  void startChange(newString) {
    setState(() {
      startDate = newString;
    });
  }

  void endChange(newString) {
    setState(() {
      endDate = newString;
    });
  }

  void dropValueChanged(newString) {
    setState(() {
      dropValue = newString;
    });
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void getCurrentUser() async {
    final currentUser = await FirebaseFunctions.getUserFromDb(
        UserPreferences.auth.currentUser!.uid);

    UserPreferences.myUser = currentUser;
    //print(t);
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  final user = UserPreferences.myUser;

  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textButtonColor = isDarkMode ? Colors.white : Colors.black;

    return RefreshIndicator(
      onRefresh: () async {
        getFirebaseShifts();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()))
                  .whenComplete(() => getFirebaseShifts());
            },
            child: const Text(
              "Profile",
              softWrap: false,
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: const Text('Logged In'),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child:
                    const Text('Logout', style: TextStyle(color: Colors.white)))
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: MyThemes.primary,
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Add Shift"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                    content: AddShiftWidget(
                      shiftDate: _focusedDay,
                      startDate: startChange,
                      endDate: endChange,
                      dropValue: dropValueChanged,
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Ok"),
                        onPressed: () async {
                          if (selectedEvents[_focusedDay] != null) {
                            Shift shift = Shift(
                                date: _focusedDay,
                                start: startDate,
                                end: endDate,
                                user: UserPreferences.myUser!.uid,
                                wanted: false,
                                approval: false,
                                job: dropValue,
                                wantedUser: '');
                            var id =
                                await FirebaseFunctions.addShiftToDb(shift);

                            selectedEvents[_focusedDay]!.add(Event(
                                title:
                                    'Start Time:${startDate.format(context)}\nEnd Time ${endDate.format(context)}\nJob:$dropValue',
                                endTime: endDate,
                                startTime: startDate,
                                job: dropValue,
                                fullName: UserPreferences.myUser!.name,
                                shiftId: id));
                          } else {
                            Shift shift = Shift(
                                date: _focusedDay,
                                start: startDate,
                                end: endDate,
                                user: UserPreferences.myUser!.uid,
                                wanted: false,
                                approval: false,
                                job: dropValue,
                                wantedUser: '');
                            var id =
                                await FirebaseFunctions.addShiftToDb(shift);

                            selectedEvents[_focusedDay] = [
                              Event(
                                  title:
                                      'Start Time:${startDate.format(context)}\nEnd Time ${endDate.format(context)}\nJob:$dropValue',
                                  startTime: startDate,
                                  endTime: endDate,
                                  job: dropValue,
                                  fullName: UserPreferences.myUser!.uid,
                                  shiftId: id)
                            ];
                          }

                          Navigator.pop(context);
                          _eventController.clear();
                          setState(() {});
                          return;
                        },
                      ),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  )),
          label: Text('Add Shift'),
          icon: Icon(Icons.add_outlined),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              headerVisible: true,
              calendarFormat: _calendarFormat,
              calendarStyle: const CalendarStyle(outsideDaysVisible: false),
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              eventLoader: _getEventsFromDay,
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
            // Expanded(
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
            // )
            ShiftListWidget(
              eventList: _getEventsFromDay(_selectedDay!),
              selectedDay: _selectedDay!,
              refresh: getFirebaseShifts,
            )

            // ..._getEventsFromDay(_selectedDay!).map(
            //   (Event event) => ListTile(
            //     title: Text(event.title),
            //   ),
            // ),

            //ShiftListWidget(eventList: _getEventsFromDay(_selectedDay!))
            // Column(
            //   children: [
            //     ElevatedButton(
            //         onPressed: () {
            //           _selectedDay ??= DateTime.now();
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) =>
            //                       ShiftDetails(shiftDate: _selectedDay!)));
            //         },
            //         child: const Text("Get My Shift covered"),
            //         style: ElevatedButton.styleFrom(
            //             primary: Colors.white,
            //             onPrimary: Colors.black,
            //             minimumSize: const Size(200, 30))),
            //     ElevatedButton(
            //         onPressed: () {},
            //         child: const Text("Open Shift"),
            //         style: ElevatedButton.styleFrom(
            //             primary: Colors.white,
            //             onPrimary: Colors.black,
            //             minimumSize: const Size(200, 30))),
            //     ElevatedButton(
            //         onPressed: () => showDialog(
            //             context: context,
            //             builder: (context) => AlertDialog(
            //                   title: Text("add Event"),
            //                   content: AddShiftWidget(
            //                     shiftDate: _focusedDay,
            //                     startDate: startChange,
            //                     endDate: endChange,
            //                   ),
            //                   actions: [
            //                     TextButton(
            //                       child: Text("Ok"),
            //                       onPressed: () {
            //                         if (selectedEvents[_selectedDay] != null) {
            //                           selectedEvents[_selectedDay]!.add(Event(
            //                               title:
            //                                   '${user.name} Shift Start Time:${startDate.format(context)}\nEnd Time ${endDate.format(context)}',
            //                               endTime: endDate,
            //                               startTime: startDate));
            //                         } else {
            //                           selectedEvents[_selectedDay!] = [
            //                             Event(
            //                                 title:
            //                                     '${user.name} Shift Start Time:${startDate.format(context)}\nEnd Time ${endDate.format(context)}',
            //                                 startTime: startDate,
            //                                 endTime: endDate)
            //                           ];
            //                         }
            //
            //                         Navigator.pop(context);
            //                         _eventController.clear();
            //                         setState(() {});
            //                         return;
            //                       },
            //                     ),
            //                     TextButton(
            //                       child: Text("Cancel"),
            //                       onPressed: () => Navigator.pop(context),
            //                     )
            //                   ],
            //                 )),
            //         child: const Text("Test Adding event"),
            //         style: ElevatedButton.styleFrom(
            //             primary: Colors.white,
            //             onPrimary: Colors.black,
            //             minimumSize: const Size(200, 30))),
            //   ],
            //)
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }
}
