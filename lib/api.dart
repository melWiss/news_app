import 'dart:async';
import 'dart:convert';
import 'news_element.dart';
import 'package:http/http.dart' as http;

class Api {
  String topstories =
      'https://news-app-wiss.herokuapp.com/getNews';
  Future<List<NewsElement>> getNews() async {
    List<NewsElement> list = [];
    var response = await jsonDecode((await http.get(topstories)).body);
    for (int i = 0; i < response.length; i++) {
      list.add(
        NewsElement(
          title: response[i]['title'],
          //html: response["articales"][i]['title'],
          subTitle: response[i]['description'],
          imageUrl: response[i]['urlToImage'],
        ),
      );
    }
    return list;
  }
}
