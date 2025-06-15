import 'package:flutter/material.dart';

class GlobalErrorMessageWidget extends StatelessWidget {
  final String? errorMessage;
  const GlobalErrorMessageWidget({Key? key, this.errorMessage})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty)
      return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
