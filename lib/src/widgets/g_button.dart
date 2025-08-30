import 'package:flutter/material.dart';

class GButton extends StatelessWidget {
  const GButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    super.key,
  });

  final Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: Icon(icon),
      ),
    );
  }
}
