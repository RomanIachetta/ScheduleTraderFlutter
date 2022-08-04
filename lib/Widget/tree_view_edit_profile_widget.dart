import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:shiftit/themes.dart';

class TreeViewEditProfileWidget extends StatefulWidget {
  final List<String> selectedItems;
  final List<String> shownItems;
  final List<String> usersJobs;
  const TreeViewEditProfileWidget({
    Key? key,
    required this.usersJobs,
    required this.selectedItems,
    required this.shownItems,
  }) : super(key: key);

  @override
  _TreeViewWidgetState createState() => _TreeViewWidgetState();
}

class _TreeViewWidgetState extends State<TreeViewEditProfileWidget> {
  @override
  Widget build(BuildContext context) {
    GroupController multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: widget.usersJobs,
    );
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SimpleGroupedCheckbox<String>(
          controller: multipleCheckController,
          itemsTitle: widget.shownItems,
          values: widget.shownItems,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
            groupTitleStyle: TextStyle(color: MyThemes.primary),
          ),
          groupTitle: "Jobs",
          checkFirstElement: false,
          helperGroupTitle: true,
          onItemSelected: (data) {
            widget.selectedItems.clear();
            widget.selectedItems.addAll(data);
            print(widget.selectedItems);
          },
          isExpandableTitle: true,
        ),
      ],
    );
  }
}
