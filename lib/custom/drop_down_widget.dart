import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final String status;
  final List<String> statusList;
  final Function(String) onTap;

  const DropDownWidget({
    Key key,
    this.status,
    this.statusList,
    this.onTap,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      //    padding: const EdgeInsets.only(left: 24, right: 24),
      margin: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          iconEnabledColor: MyTheme.grey_153,
          isExpanded: true,
          // value: widget.status,
          hint: Text(widget.status,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: MyTheme.grey_153,
              ),
              maxLines: 1,
              textAlign: TextAlign.left),
          items: widget.statusList.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          onChanged: widget.onTap,
        ),
      ),
    );
  }
}
