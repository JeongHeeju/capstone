import 'package:flutter/material.dart';
import 'package:flutter_projects/screen/health_screen.dart';
import 'package:provider/provider.dart';


class HealthProvider with ChangeNotifier {
  HealthInfo _info = HealthInfo(
    gender: '',
    birthdate: null,
    height: 0.0,
    weight: 0.0,
    conditions: [],
  );

  HealthInfo get info => _info;

  void setInfo(HealthInfo newInfo) {
    _info = newInfo;
    notifyListeners();
  }
}