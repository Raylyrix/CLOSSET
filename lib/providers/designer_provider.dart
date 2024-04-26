import 'package:CLOSSET/models/designer.dart';
import 'package:flutter/material.dart';

class DesignerProvider extends ChangeNotifier {
  Designer _designer = Designer(
    id: 0,
    userID: 0,
    brandName: '',
  );

  Designer get designer => _designer;

  Future<void> setDesigner(Designer designer) async {
    _designer = designer;
    notifyListeners();
  }
}
