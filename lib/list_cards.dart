import 'package:flutter/material.dart';
import 'package:news_app/colors.dart';
import 'news_element.dart';
import 'package:url_launcher/url_launcher.dart';

class CardsList extends StatelessWidget {
  final List<NewsElement> children;
  final Function onTap;
  CardsList({
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
          child: Card(
            elevation: 3,
            borderOnForeground: true,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                if (onTap == null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewsDetails(
                        news: children[index],
                      ),
                    ),
                  );
                } else {
                  onTap(index);
                }
              },
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
                              right: MediaQuery.of(context).size.width * .1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
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
  final Function save;
  final Function onExist;
  final double snackBarWidth;
  NewsDetails({this.news, this.save, this.snackBarWidth, this.onExist});
  @override
  Widget build(BuildContext context) {
    var readButton = FlatButton.icon(
      onPressed: () => launch(news.html),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: NewsColors.accent,
      ),
      label: Text(
        'Read the article',
        style: TextStyle(color: NewsColors.accent),
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(news.title != null ? news.title : ''),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.bookmark,
                color: NewsColors.primary,
              ),
              tooltip: 'Save Article',
              onPressed: () async {
                if (save != null) {
                  if (await save()) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Saved to read later'),
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? snackBarWidth
                          : MediaQuery.of(context).size.width,
                      behavior: SnackBarBehavior.floating,
                    ));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Already saved'),
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? snackBarWidth
                          : MediaQuery.of(context).size.width,
                      behavior: SnackBarBehavior.floating,
                      action: onExist != null
                          ? SnackBarAction(
                              label: 'Delete',
                              textColor: NewsColors.accent,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text(
                                        'Delete?',
                                        style: TextStyle(
                                          color: NewsColors.primary,
                                        ),
                                      ),
                                      content: Text(
                                          'Do you want to delete ${news.title} article?'),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
                                            await onExist();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: NewsColors.accent,
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: NewsColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            )
                          : null,
                    ));
                  }
                } else {
                  print("save is null");
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          news.imageUrl != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
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
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .02,
                      ),
                      child: readButton,
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: readButton,
                ),
        ],
      ),
    );
  }
}
