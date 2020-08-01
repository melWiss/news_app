import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'articles_rx.dart';
import 'colors.dart';
import 'api.dart';
import 'db.dart';
import 'news_element.dart';
import 'list_cards.dart';

GetIt getIt = GetIt.asNewInstance();
void main() {
  getIt.registerSingleton<ListArticles>(ListArticles());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white, foregroundColor: NewsColors.accent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: NewsColors.deactivate,
            selectedItemColor: NewsColors.primary),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(),
          centerTitle: false,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: NewsColors.primary,
              fontSize: 20,
            ),
          ),
        ),
      ),
      home: MyHomePage(title: 'News App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomIndex = 0;
  Api api;
  List<NewsElement> listNews;
  Widget listElement;
  Widget body;
  ListArticles _listArticles = getIt.get<ListArticles>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listElement = Center(
      child: CircularProgressIndicator(),
    );
    api = Api();
    body = Center(
      child: Text(
        'Tap on an article from the left',
        style: TextStyle(fontSize: 18),
      ),
    );
    getNews();
  }

  void getNews() {
    api.getNews().then((value) {
      setState(() {
        listNews = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthRail = MediaQuery.of(context).size.width * .15 + 16;
    if (listNews != null) {
      if (listNews.length == 0) {
        listElement = Center(
          child: Text("Save News from the News tab"),
        );
      } else if (MediaQuery.of(context).orientation == Orientation.landscape)
        listElement = CardsList(
          children: listNews,
          onTap: (int index) {
            setState(() {
              body = NewsDetails(
                news: listNews[index],
                snackBarWidth: MediaQuery.of(context).size.width * .5,
                save: () async =>
                    putData(listNews[index].toMap(), listNews[index].html),
                onExist: () =>
                    deleteData(listNews[index].html).whenComplete(() async {
                  setState(() {
                    print("Deleted ${listNews[index].title}");
                  });
                }),
              );
            });
          },
        );
      else
        listElement = CardsList(
          children: listNews,
          onTap: (int index) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewsDetails(
                news: listNews[index],
                snackBarWidth: MediaQuery.of(context).size.width * .5,
                save: () async =>
                    putData(listNews[index].toMap(), listNews[index].html),
                onExist: () =>
                    deleteData(listNews[index].html).whenComplete(() async {
                  setState(() {
                    print("Deleted ${listNews[index].title}");
                  });
                }),
              ),
            ));
          },
        );
    } else {
      listElement = Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 1.5,
        leading: Icon(
          Icons.account_balance,
          color: NewsColors.primary,
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          //landscape
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: NavigationRail(
                      elevation: 3,
                      selectedIndex: bottomIndex,
                      extended: widthRail >= 152.2 ? true : false,
                      labelType: widthRail < 152.2
                          ? NavigationRailLabelType.selected
                          : NavigationRailLabelType.none,
                      onDestinationSelected: (index) async {
                        setState(() {
                          bottomIndex = index;
                          listNews = null;
                        });
                        switch (index) {
                          case 0:
                            getNews();
                            break;
                          case 1:
                            {
                              var localNews = await getData();
                              setState(() {
                                listNews = List.generate(
                                  localNews.length,
                                  (index) {
                                    return NewsElement.fromMap(
                                        localNews[index]);
                                  },
                                );
                              });
                            }
                            break;
                          default:
                        }
                      },
                      leading: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: floatingActionButton(
                          extended: widthRail >= 152.2,
                        ),
                      ),
                      destinations: <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.assignment,
                          ),
                          label: Text('News'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            Icons.save,
                          ),
                          label: Text('Saved'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: listElement,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: body,
                    ),
                  )
                ],
              ),
            );
          }
          //portrait
          else {
            return listElement;
          }
        },
      ),
      floatingActionButton:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? floatingActionButton()
              : null,
      bottomNavigationBar:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? BottomNavigationBar(
                  currentIndex: bottomIndex,
                  onTap: (index) async {
                    setState(() {
                      bottomIndex = index;
                      listNews = null;
                    });
                    switch (index) {
                      case 0:
                        getNews();
                        break;
                      case 1:
                        {
                          var localNews = await getData();
                          setState(() {
                            listNews = List.generate(
                              localNews.length,
                              (index) {
                                return NewsElement.fromMap(localNews[index]);
                              },
                            );
                          });
                        }
                        break;
                      default:
                    }
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      title: Text("News"),
                      icon: Icon(
                        Icons.assignment,
                      ),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Saved"),
                      icon: Icon(
                        Icons.save,
                      ),
                    ),
                  ],
                )
              : null,
    );
  }

  FloatingActionButton floatingActionButton({bool extended = true}) {
    if (extended) {
      return FloatingActionButton.extended(
        label: Text("Add Field"),
        onPressed: () async {},
        tooltip: 'Add Field',
        icon: Icon(Icons.add),
      );
    }
    return FloatingActionButton(
      onPressed: () async {},
      tooltip: 'Add Field',
      child: Icon(Icons.add),
    );
  }

  IndexedStack bodyStack(BuildContext context) {
    return IndexedStack(
      index: bottomIndex,
      children: [
        listElement,
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blueAccent,
        ),
      ],
    );
  }
}
