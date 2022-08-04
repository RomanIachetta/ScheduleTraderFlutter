import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:shiftit/themes.dart';
import 'package:shiftit/utils/constants.dart';

class TreeViewWidget extends StatefulWidget {
  final List<String> selectedItems;
  final List<String> shownItems;
  const TreeViewWidget(
      {Key? key, required this.selectedItems, required this.shownItems})
      : super(key: key);

  @override
  _TreeViewWidgetState createState() => _TreeViewWidgetState();
}

class _TreeViewWidgetState extends State<TreeViewWidget> {
  // final List<String> productionitems = [
  //   "palletizing",
  //   "relief ",
  //   "packing",
  // ];

  List<String> test = [];
  @override
  Widget build(BuildContext context) {
    GroupController multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: Constants.productionList,
    );
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SimpleGroupedCheckbox<String>(
          controller: multipleCheckController,
          itemsTitle: Constants.productionList,
          values: Constants.productionList,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
            groupTitleStyle: TextStyle(color: MyThemes.primary),
          ),
          groupTitle: "Jobs",
          checkFirstElement: false,
          helperGroupTitle: true,
          onItemSelected: (data) {
            //print(data);
            //widget.callback(data);
            //widget.selectedItems = data;
            // widget.customFunction(data);
            //
            // if (data.length != 0) {
            //   widget.selectedItems.clear();
            //   widget.selectedItems.addAll(data);
            // } else {
            //   //widget.selectedItems.clear();
            //   widget.selectedItems.remove(data);
            // }
            widget.selectedItems.clear();
            widget.selectedItems.addAll(data);
            print(widget.selectedItems);
            //print(data);
          },
          isExpandableTitle: true,
        ),
      ],
    );
    // return Expanded(
    //   child: _SimpleGrouped(
    //     customFunction: widget.customFunction,
    //     callback: widget.callback,
    //     selectedItems: widget.selectedItems,
    //   ),
    // );
  }
}

class _SimpleGrouped extends StatelessWidget {
  final customFunction;

  List<String> selectedItems;
  final List<String> productionitems = [
    "palletizing",
    "relief ",
    "packing",
  ];

  _SimpleGrouped({required this.selectedItems, required this.customFunction});

  @override
  Widget build(BuildContext context) {
    GroupController controller = GroupController(initSelectedItem: [2]);
    GroupController switchController = GroupController();
    GroupController chipsController =
        GroupController(isMultipleSelection: true);
    GroupController multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: productionitems,
    );

    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SimpleGroupedCheckbox<String>(
            controller: multipleCheckController,
            itemsTitle: productionitems,
            values: productionitems,
            groupStyle: GroupStyle(
              activeColor: Colors.green,
              groupTitleStyle: TextStyle(color: MyThemes.primary),
            ),
            groupTitle: "Productions",
            checkFirstElement: false,
            helperGroupTitle: true,
            onItemSelected: (data) {
              //print(data);
              //callback(data);
              selectedItems = data;

              print(selectedItems);
              customFunction(data);
            },
            isExpandableTitle: true,
          ),
          // const SizedBox(
          //   height: 24,
          // ),
          // SimpleGroupedCheckbox<String>(
          //   controller: multipleCheckController,
          //   itemsTitle: productionitems,
          //   values: productionitems,
          //   groupStyle: GroupStyle(
          //     activeColor: Colors.green,
          //     groupTitleStyle: TextStyle(color: MyThemes.primary),
          //   ),
          //   groupTitle: "test",
          //   checkFirstElement: false,
          //   helperGroupTitle: true,
          //   onItemSelected: (data) {
          //     print(data);
          //     //callback(data);
          //   },
          //   isExpandableTitle: true,
          // ),
        ],
      ),
    );
  }
}
