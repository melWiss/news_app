import 'dart:async';
import 'dart:convert';
import 'news_element.dart';
import 'package:http/http.dart' as http;

class Api {
  String topstories =
      'http://newsapi.org/v2/top-headlines?country=us&apiKey=f599cb8706914e578b866c0d0dc58a4f';
  Future<List<NewsElement>> getNews() async {
    List<NewsElement> list = [];
    var response = await jsonDecode((await http.get(topstories)).body);
    for (int i = 0; i < response['articles'].length; i++) {
      list.add(
        NewsElement(
          title: response["articles"][i]['title'],
          //html: response["articales"][i]['title'],
          subTitle: response["articles"][i]['description'],
          imageUrl: response["articles"][i]['urlToImage'],
        ),
      );
    }
    return list;
  }
}
