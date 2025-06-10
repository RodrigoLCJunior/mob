import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey[400])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Ou",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey[400])),
      ],
    );
  }
}
