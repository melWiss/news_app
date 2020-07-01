import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  final articleData;
  const ArticleScreen(
    this.articleData,
  );

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Title : ${widget.articleData['title']}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child:
                          Text('Date :  ${widget.articleData['publishedAt']} '),
                    ),
                  ],
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.network(
                    widget.articleData['urlToImage'],
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  child: Text(widget.articleData['description']),
                )
              ],
            ),
          )),
    );
  }
}
