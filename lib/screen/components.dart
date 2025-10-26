// Modify the transactionButton function to accept onTap callback
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

Widget transactionButton(IconData icon, String label, {VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: Colors.blue[900]),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
