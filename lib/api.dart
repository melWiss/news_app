import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'news_element.dart';
import 'package:http/http.dart' as http;

class Api {
  String topstories = (kIsWeb && kReleaseMode)? '../getNews':'https://news-app-wiss.herokuapp.com/getNews'/*'http://localhost:8080/getNews'*/;
  Future<List<NewsElement>> getNews() async {
    List<NewsElement> list = [];
    var response = await jsonDecode((await http.get(topstories)).body);
    for (int i = 0; i < response.length; i++) {
      list.add(
        NewsElement(
          title: response[i]['title'],
          html: response[i]['url'],
          subTitle: response[i]['description'],
          imageUrl: response[i]['urlToImage'],
        ),
      );
    }
    return list;
  }
}
