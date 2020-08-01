import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'articles_rx.dart';
import 'colors.dart';
import 'api.dart';
import 'db.dart';
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
  ListArticles _listArticles = getIt.get<ListArticles>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listArticles.apiArticles().whenComplete(() {
      _listArticles.articlesProviderSelector(0);
    });
    _listArticles.localArticles();
  }

  @override
  Widget build(BuildContext context) {
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
            var widthRail = MediaQuery.of(context).size.width * .15 + 16;
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
                        });
                        _listArticles.articlesProviderSelector(index);
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
                    child: ListArticlesWidget(
                      listArticles: _listArticles,
                      bottomIndex: bottomIndex,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: StreamBuilder(
                        stream: _listArticles.indexStream$,
                        initialData: -1,
                        builder: (context, snap) {
                          switch (snap.connectionState) {
                            case ConnectionState.active:
                              print(_listArticles.currentIndex);
                              if (_listArticles.current.length >
                                      _listArticles.currentIndex &&
                                  _listArticles.currentIndex > -1)
                                return NewsDetails(
                                  news: _listArticles
                                      .current[_listArticles.currentIndex],
                                  onExist: () => deleteData(_listArticles
                                          .current[_listArticles.currentIndex]
                                          .html)
                                      .whenComplete(() async {
                                    await _listArticles
                                        .articlesProviderSelector(bottomIndex);
                                  }),
                                  save: () {
                                    return putData(
                                      _listArticles
                                          .current[_listArticles.currentIndex]
                                          .toMap(),
                                      _listArticles
                                          .current[_listArticles.currentIndex]
                                          .html,
                                    );
                                  },
                                  snackBarWidth:
                                      MediaQuery.of(context).size.width * .5,
                                );
                              return Center(
                                child: Text(
                                  'Tap on an article from the left',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                              break;
                            default:
                              return Center(
                                child: Text(
                                  'Tap on an article from the left',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          //portrait
          else {
            return ListArticlesWidget(
              listArticles: _listArticles,
              bottomIndex: bottomIndex,
            );
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
                    });
                    _listArticles.articlesProviderSelector(index);
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
}

class ListArticlesWidget extends StatelessWidget {
  const ListArticlesWidget({
    Key key,
    this.bottomIndex = 0,
    @required ListArticles listArticles,
  })  : _listArticles = listArticles,
        super(key: key);

  final ListArticles _listArticles;
  final int bottomIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _listArticles.stream$,
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.active:
            print('active');
            if (_listArticles.current.length > 0)
              return CardsList(
                children: _listArticles.current,
                onTap: (int index) async {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape) {
                    if (bottomIndex == 0)
                      _listArticles.apiNewsIndex(index);
                    else
                      _listArticles.localNewsIndex(index);
                    await _listArticles.articlesProviderSelector(bottomIndex);
                  } else {
                    if (bottomIndex == 0)
                      _listArticles.apiNewsIndex(index);
                    else
                      _listArticles.localNewsIndex(index);
                    await _listArticles.articlesProviderSelector(bottomIndex);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(
                          news:
                              _listArticles.current[_listArticles.currentIndex],
                          save: () {
                            return putData(
                              _listArticles.current[_listArticles.currentIndex]
                                  .toMap(),
                              _listArticles
                                  .current[_listArticles.currentIndex].html,
                            );
                          },
                          onExist: () => deleteData(_listArticles
                                  .current[_listArticles.currentIndex].html)
                              .whenComplete(() async {
                            await _listArticles
                                .articlesProviderSelector(bottomIndex);
                            Navigator.of(context).pop();
                          }),
                          snackBarWidth:
                              MediaQuery.of(context).size.width * .97,
                        ),
                      ),
                    );
                  }
                },
              );
            return Center(
                child: Text(
              bottomIndex == 1
                  ? "Save some articles from the News Tab"
                  : "Check Internet Connectivity",
              textAlign: TextAlign.center,
            ));
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
