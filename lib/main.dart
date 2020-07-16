import 'package:flutter/material.dart';
import 'colors.dart';
import 'api.dart';
import 'main_live.dart';
import 'news_element.dart';
import 'list_cards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      routes: {
        "/live": (context) => MyHomePageLive(
              title: 'News App',
            )
      },
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
  int _counter = 0;
  int bottomIndex = 0;
  Api api;
  List<NewsElement> listNews;
  Widget listElement;
  Widget body;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
      if (MediaQuery.of(context).orientation == Orientation.landscape)
        listElement = CardsListLandscape(
          children: listNews,
          onTap: (int index) {
            setState(() {
              body = NewsDetails(
                news: listNews[index],
              );
            });
          },
        );
      else
        listElement = CardsListPortrait(children: listNews);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /*actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => Navigator.of(context).pushNamed("/live"))
        ],*/
        leading: Icon(Icons.account_balance,color: NewsColors.primary,),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .15,
                    child: Material(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                      clipBehavior: Clip.hardEdge,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NavigationRail(
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
                          selectedIndex: bottomIndex,
                          extended: widthRail >= 152.2 ? true : false,
                          leading: floatingActionButton(
                              extended: widthRail >= 152.2),
                          minExtendedWidth: 152.2,
                          labelType: widthRail < 152.2
                              ? NavigationRailLabelType.selected
                              : NavigationRailLabelType.none,
                          onDestinationSelected: (index) {
                            setState(() {
                              bottomIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: listElement,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: body,
                    ),
                  )
                ],
              ),
            );
          }
          //portrait
          else {
            return bodyStack(context);
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
                  onTap: (index) {
                    setState(() {
                      bottomIndex = index;
                    });
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
        onPressed: _incrementCounter,
        tooltip: 'Add Field',
        icon: Icon(Icons.add),
      );
    }
    return FloatingActionButton(
      onPressed: _incrementCounter,
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
