import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitnessapp/Models/Exersice_Model.dart';

class ExersiceService with ChangeNotifier {
  List<ExersiceModel> exersices = [];
  bool isLoading = false;
  String errorMessage = '';

  List<ExersiceModel> get getExersices => exersices;
  bool get getIsLoading => isLoading;
  String get getErrorMessage => errorMessage;


  Future getExersicesApi(String query) async {
    final String baseUrl = "https://api.api-ninjas.com";
    final Map<String, String> headers = {
      'X-Api-Key': 'YHIm6jx+HoAzx1wLqnhdbw==tUvGSEZZPoaw0olL',
    };
    final Uri url = Uri.parse('$baseUrl/v1/exercises?muscle=$query');

    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('API Response: $data'); // Log the response for debugging
        exersices = data.map((item) => ExersiceModel.fromJson(item)).toList();
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
      print('API call completed $exersices');
      isLoading = false;
      notifyListeners();
    }
  }
}
