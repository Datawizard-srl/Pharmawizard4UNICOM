import 'package:flutter/material.dart';

abstract class AbsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;

  const AbsButton({super.key, required this.onPressed, required this.child, this.backgroundColor});

}