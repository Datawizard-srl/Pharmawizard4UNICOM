import 'package:flutter/material.dart';

import 'abstacts.dart';

class PrimaryButton extends AbsButton {
  const PrimaryButton({super.key, required super.onPressed, required super.child, super.backgroundColor});

  @override
  Widget build(BuildContext context) {
    MaterialStatePropertyAll<Color> backgroundColor;
    if (super.backgroundColor != null){
      backgroundColor = MaterialStatePropertyAll<Color>(super.backgroundColor!);
    } else {
      backgroundColor = MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.primary);
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: backgroundColor,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      )
    );
  }

}
