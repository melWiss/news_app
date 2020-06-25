import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/colors.dart';
import 'news_element.dart';

class CardsList extends StatelessWidget {
  final List<NewsElement> children;
  CardsList({@required this.children});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (buildContext, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewsDetails(
                    news: children[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              borderOnForeground: true,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          children[index].imageUrl,
                          height: MediaQuery.of(context).size.height * .25,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: MediaQuery.of(context).size.width * .2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: NewsColors.accent,
                            child: Text(
                              children[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .12,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      children[index].subTitle,
                      maxLines: 5,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewsDetails extends StatelessWidget {
  final NewsElement news;
  NewsDetails({
    this.news,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(news.title),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(news.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              news.subTitle,
            style: TextStyle(
              fontSize: 18
            ),),
          ),
          Html(
            data: news.html,
          )
        ],
      ),
    );
  }
}
