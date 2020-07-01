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
        "/live":(context)=>MyHomePageLive(title: 'News App',)
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
          centerTitle: true,
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
  Widget list;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = Container();
    api = Api();
    api.getNews().then((value) {
      setState(() {
        list = CardsList(children: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: bottomIndex,
        children: [
          list,
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueAccent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Field"),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
