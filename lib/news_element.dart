import 'package:news_app/colors.dart';

class NewsElement {
  String title, subTitle, imageUrl, html;
  NewsElement({
    this.title = "",
    this.html = "",
    this.imageUrl = "",
    this.subTitle = "",
  });

  NewsElement.fromMap(Map data) {
    this.title = data['title'];
    this.html = data['html'];
    this.imageUrl = data['imageUrl'];
    this.subTitle = data['subTitle'];
  }

  Map toMap() {
    return {
      'title':this.title,
      'html':this.html,
      'imageUrl':this.imageUrl,
      'subTitle':this.subTitle,
    };
  }
}
