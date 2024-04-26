import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

dateToDayMonthYear(DateTime date) {
  String day = date.toString().substring(0, 10);
  final year = day.substring(0, 4);
  final month = day.substring(5, 7);
  final dayy = day.substring(8, 10);
  return "$dayy-$month-$year";
}
