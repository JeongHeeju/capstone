import 'package:flutter/material.dart';

class AllergyProvider with ChangeNotifier {
  List<String> _allergies = [];

  List<String> get allergies => _allergies;

  void toggleAllergy(String allergy) {
    if (_allergies.contains(allergy)) {
      _allergies.remove(allergy);
    } else {
      _allergies.add(allergy);
    }
    notifyListeners();
  }

  void setAllergies(List<String> list) {
    _allergies = list;
    notifyListeners();
  }
}