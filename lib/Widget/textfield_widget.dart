import 'package:flutter/material.dart';
import 'package:shiftit/utils/user_preferences.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  late String text;
  final ValueChanged<String> onChanged;
  TextFieldWidget(
      {Key? key,
      required this.label,
      required this.text,
      required this.onChanged})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
    controller.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    // print('Second text field: ${controller.text}');
    widget.onChanged.call(controller.text);
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            controller: controller,
          ),
        ],
      );
}
