import 'package:CLOSSET/models/manufacturer.dart';
import 'package:flutter/material.dart';

class ManufacturerProvider with ChangeNotifier {
  Manufacturer? _manufacturer;

  Manufacturer? get manufacturer => _manufacturer;

  void setManufacturer(Manufacturer manufacturer) {
    _manufacturer = manufacturer;
    notifyListeners();
  }
}
