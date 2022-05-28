import 'package:flutter/material.dart';

SnackBar showSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('No internet connect!', style: TextStyle(color: Colors.red),),
    backgroundColor: (Colors.black),
    action: SnackBarAction(
      label: 'dismiss',
      onPressed: () {},
    ),
  );
  return snackBar;
}
