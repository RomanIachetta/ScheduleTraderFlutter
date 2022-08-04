import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftit/model/event.dart';

class SelectShiftWidget extends StatefulWidget {
  final Event event;
  final DateTime selectedDay;

  const SelectShiftWidget(
      {Key? key, required this.event, required this.selectedDay})
      : super(key: key);

  @override
  _SelectShiftWidgetState createState() => _SelectShiftWidgetState();
}

class _SelectShiftWidgetState extends State<SelectShiftWidget> {
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
              text: 'Date: ',
              style: TextStyle(
                fontSize: 24,
                color: textColor,
              ),
              children: [
                TextSpan(
                    text: DateFormat('yyyy-MM-dd').format(widget.selectedDay),
                    style: TextStyle(
                        color: textColor,
                        decoration: TextDecoration.underline)),
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
                  text: widget.event.startTime.format(context),
                  style: const TextStyle(
                      decoration: TextDecoration.underline, fontSize: 24),
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
                  text: widget.event.endTime.format(context),
                  style: const TextStyle(
                      decoration: TextDecoration.underline, fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: 'Job: ',
              style: TextStyle(fontSize: 24, color: textColor),
              children: [
                TextSpan(
                  text: widget.event.job,
                  style: const TextStyle(
                      decoration: TextDecoration.underline, fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
