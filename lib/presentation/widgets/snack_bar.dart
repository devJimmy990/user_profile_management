import 'package:flutter/material.dart';

SnackBar buildSnackBar({required String label, SnackBarAction? action}) =>
    SnackBar(
      content: Text(label),
      action: action,
    );
