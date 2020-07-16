import 'package:flutter/material.dart';
import 'package:news_app/colors.dart';
import 'news_element.dart';
import 'package:url_launcher/url_launcher.dart';

class CardsListPortrait extends StatelessWidget {
  final List<NewsElement> children;
  CardsListPortrait({@required this.children});
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
                        child: children[index].imageUrl != null
                            ? Image.network(
                                children[index].imageUrl,
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                      children[index].title != null
                          ? Positioned(
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
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: children[index].subTitle != null
                          ? Text(
                              children[index].subTitle,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14),
                            )
                          : Container(),
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

class CardsListLandscape extends StatelessWidget {
  final List<NewsElement> children;
  final Function onTap;
  CardsListLandscape({
    @required this.children,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (buildContext, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              onTap(index);
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
                        child: children[index].imageUrl != null
                            ? Image.network(
                                children[index].imageUrl,
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                      children[index].title != null
                          ? Positioned(
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
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: children[index].subTitle != null
                          ? Text(
                              children[index].subTitle,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14),
                            )
                          : Container(),
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
  NewsDetails({this.news});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(news.title != null ? news.title : ''),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          news.imageUrl != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    color: Colors.white,
                    child: Image.network(
                      news.imageUrl,
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width * .6,
                      fit: BoxFit.cover,
                    ),
                    clipBehavior: Clip.antiAlias,
                  ),
                )
              : Container(),
          news.subTitle != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    news.subTitle,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Container(),
          FlatButton.icon(
            onPressed: () => launch(news.html),
            icon: Icon(
              Icons.arrow_forward_ios,
              color: NewsColors.accent,
            ),
            label: Text(
              'Read the article',
              style: TextStyle(
                color: NewsColors.accent
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          )
        ],
      ),
    );
  }
}
