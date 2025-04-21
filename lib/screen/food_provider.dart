import 'package:flutter/material.dart';

class FoodProvider extends ChangeNotifier {
  final List<String> _selectedFoods = [];

  List<String> get selectedFoods => _selectedFoods;

  void toggleFood(String food) {
    if (_selectedFoods.contains(food)) {
      _selectedFoods.remove(food);
    } else {
      _selectedFoods.add(food);
    }
    notifyListeners();
  }

  void clearFoods() {
    _selectedFoods.clear();
    notifyListeners();
  }

  void setSelectedFoods(List<String> foods) {
    _selectedFoods
      ..clear()
      ..addAll(foods);
    notifyListeners();
  }
}