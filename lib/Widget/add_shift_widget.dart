import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftit/utils/constants.dart';
import 'package:shiftit/utils/user_preferences.dart';

class AddShiftWidget extends StatefulWidget {
  final DateTime shiftDate;
  final startDate;
  final endDate;
  final dropValue;
  const AddShiftWidget(
      {Key? key,
      required this.shiftDate,
      required this.startDate,
      required this.endDate,
      required this.dropValue})
      : super(key: key);

  @override
  _AddShiftWidgetState createState() => _AddShiftWidgetState();
}

class _AddShiftWidgetState extends State<AddShiftWidget> {
  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 15);
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 15);
  final TimeOfDay _initialTime = const TimeOfDay(hour: 7, minute: 15);
  String dropdownValue = UserPreferences.myUser!.jobs.first;

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
        widget.startDate(newTime);
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
        widget.endDate(newTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  text: _startTime.format(context),
                  style: const TextStyle(
                      color: Colors.blue,
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
                  text: _endTime.format(context),
                  style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 24),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _selectEndTime();
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
              widget.dropValue(newValue);
            });
          },
          items: UserPreferences.myUser!.jobs
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
