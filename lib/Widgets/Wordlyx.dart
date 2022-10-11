import 'package:flutter/material.dart';
import 'package:wordlyx/Utils/PersonalColors.dart';

class Wordlyx extends StatelessWidget {
  const Wordlyx({
    Key? key,
    required this.clr,
  }) : super(key: key);

  final PersonalColors clr;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Wordlyx",
      style: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: clr.white
      ),
    );
  }
}