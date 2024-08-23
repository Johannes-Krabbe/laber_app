import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isPrimary;

  const Button({super.key, required this.text, required this.onPressed, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isPrimary ? Colors.white : Colors.transparent,
        ),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
