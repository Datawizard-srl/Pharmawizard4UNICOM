import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:unicom_patient/themes/colors.dart';

class BaseDropdown<T> extends StatefulWidget {
  final LinkedHashMap<T, Widget> dropdownItems;
  final ValueChanged? onChanged;
  final Color? backgroundColor;
  final T? selected;

  const BaseDropdown({super.key, required this.dropdownItems, this.onChanged, this.selected, this.backgroundColor});

  @override
  State<BaseDropdown> createState() => _BaseDropdownState<T>();
}

class _BaseDropdownState<T> extends State<BaseDropdown> {
  late T dropdownValue;

  @override
  void initState() {
    if(widget.selected == null || !widget.dropdownItems.containsKey(widget.selected)){
      dropdownValue = widget.dropdownItems.keys.first;
    } else {
      dropdownValue = widget.selected!;
    }
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: dividerColor)
      ),
      child: DropdownButton<T>(
        underline: const SizedBox(),
        isExpanded: true,
        value: dropdownValue,
        items: widget.dropdownItems.keys.map((key) =>
            DropdownMenuItem<T>(
              value: key,
              child: widget.dropdownItems[key]!,
            )
        ).toList(),
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {
            dropdownValue = value as T;
          });
        },
      ),
    );
  }
}
