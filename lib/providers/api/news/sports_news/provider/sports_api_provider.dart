import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/providers/api/news/sports_news/model/sports_model.dart';

class SportsApiProvider {
  final Dio _dio = Dio();
  // api's URL
  final String _url = "";
  //'https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey='; // Missing Key

  // GET REQUEST for Sports News
  Future<SportsModel> getSportNews() async {
    if (_url.isEmpty) {
      return SportsModel.withError("Error occured. Url is empty.");
    } else {
      try {
        Response response = await _dio.get(_url);
        return SportsModel.fromJson(response.data);
      } catch (error, stacktrace) {
        if (kDebugMode) {
          print('Exception occured: $error stacktrace: $stacktrace');
        }
      }
      return SportsModel.withError("Error occured");
    }
  }
}
