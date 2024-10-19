import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton(
      {super.key,
      required this.ButtonText,
      this.onTap,
      required this.color,
      required this.textColor});
  final String ButtonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => onTap!));
      },
      child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
              color: color!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
              )),
          child: Text(
            ButtonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textColor!,
            ),
          )),
    );
  }
}
