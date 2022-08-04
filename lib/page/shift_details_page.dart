import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftDetails extends StatefulWidget {
  final DateTime shiftDate;

  const ShiftDetails({Key? key, required this.shiftDate}) : super(key: key);

  @override
  _ShiftDetailsState createState() => _ShiftDetailsState();
}

class _ShiftDetailsState extends State<ShiftDetails> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  String dropdownValue = 'One';

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Shift Details'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: 'Date ',
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                ),
                children: [
                  TextSpan(
                      text: DateFormat('yyyy-MM-dd').format(widget.shiftDate),
                      style: TextStyle(
                        color: textColor,
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: 'Start Time: ',
                style: TextStyle(fontSize: 24, color: textColor),
                children: [
                  TextSpan(
                    text: _time.format(context),
                    style: TextStyle(
                        color: textColor,
                        decoration: TextDecoration.underline,
                        fontSize: 24),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _selectTime();
                      },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: 'End Time: ',
                style: TextStyle(fontSize: 24, color: textColor),
                children: [
                  TextSpan(
                    text: _time.format(context),
                    style: TextStyle(
                        color: textColor,
                        decoration: TextDecoration.underline,
                        fontSize: 24),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _selectTime();
                      },
                  ),
                ],
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoggedInWidget()));
            },
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: const Size(double.infinity, 20),
            ),
          ),
        ],
      ),
    );
    // return Stack(
    //       alignment: Alignment.center,
    //   children: [
    //     Text(widget.shiftDate.toString()),
    //     ElevatedButton(
    //       child: Text("Select Start Time"),onPressed: (){},
    //     ),
    //   ],
    // );
  }
}
