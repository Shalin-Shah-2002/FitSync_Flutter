import 'package:fitnessapp/Models/Itemsmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CaloriesFood with ChangeNotifier {
  List<Itemsmodel> items = [];
  bool isLoading = false;
  String errorMessage = '';

  List<Itemsmodel> get getItems => items;
  bool get getIsLoading => isLoading;
  String get getErrorMessage => errorMessage;

  Future<void> apifuntion(String query, int page) async {
    final String baseUrl = "https://myfitnesspal2.p.rapidapi.com";
    final Map<String, String> headers = {
      'x-rapidapi-key': '770c5217aamsh4036dfd7808321dp197313jsnaf3d0399a3b3',
      'x-rapidapi-host': 'myfitnesspal2.p.rapidapi.com',
    };

    final Uri url =
        Uri.parse('$baseUrl/searchByKeyword?keyword=$query&page=1');

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('API Response: $data'); // Log the response for debugging

        items =  data.map((item) => Itemsmodel.fromJson(item)).toList();
        notifyListeners();

      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      errorMessage = 'Failed to load data: $error';
      throw Exception(errorMessage);
    } finally {
      print('API call completed $items');
      isLoading = false;
      notifyListeners();
    }
  }
}
