import 'package:flutter/material.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _selectedindex = 0;
  int get selectedindex => _selectedindex;

  void setindex(int index) {
    _selectedindex = index;
    print(index);
    print(_selectedindex);
    notifyListeners();
  }
}
