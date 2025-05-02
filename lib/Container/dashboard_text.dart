import 'package:flutter/material.dart';

class DashboardText extends StatefulWidget {
  final String keyText;
  final String valueText;

  const DashboardText({
    super.key,
    required this.keyText,
    required this.valueText,
  });

  @override
  State<DashboardText> createState() => _DashboardTextState();
}

class _DashboardTextState extends State<DashboardText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.keyText} : ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          "${widget.valueText} ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
