import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
//import 'package:news_app/articles_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/live": (context) => MyHomePageLive(
              title: 'News App',
            )
      },
      initialRoute: "/live",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'News App'),
    );
  }
}

class MyHomePageLive extends StatefulWidget {
  MyHomePageLive({Key key, this.title}) : super(key: key);
  String title;

  @override
  _MyHomePageStateLive createState() => _MyHomePageStateLive();
}

class _MyHomePageStateLive extends State<MyHomePageLive> {
  Future getData() async {
    var url = 'https://news-app-wiss.herokuapp.com/getNews';
    var response =
        await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      //print(response.body);
    } else {
      print('Error occured ${response.statusCode}');
      return "error";
    }
    return response.body;
  }

  Widget detailsScreen;
  Widget listArticles;
  var data, articles;
  bool error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hello from initState!");
    error = true;
    getData().then((value) {
      setState(() {
        if (value != "error") {
          articles = json.decode(value);
          error = false;
        } else {
          error = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: width > height
          ? Row(
              children: [
                error
                    ? Container(
                        width: width * .2,
                        height: height,
                        color: Colors.teal,
                        child: Center(
                          child: Text("ERROR"),
                        ),
                      )
                    : Container(
                        height: height,
                        width: width * .2,
                        //color: Colors.green,
                        child: ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    detailsScreen = Container(
                                      width: width * .8,
                                      height: height,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(12),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child: Image.network(
                                                    articles[index]
                                                        ['urlToImage'],
                                                    height: height * .5,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                articles[index]['title'],
                                                style: TextStyle(fontSize: 35),
                                              ),
                                              Text(
                                                articles[index]['content'],
                                                style: TextStyle(fontSize: 23),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Material(
                                  elevation: 4,
                                  borderOnForeground: true,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: Container(
                                      width: 100,
                                      color: Colors.yellow,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              articles[index]['urlToImage']),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                Text(articles[index]['title']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                detailsScreen == null
                    ? Container(
                        height: height,
                        width: width * .8,
                        //color: Colors.blue,
                        child: Center(
                          child: Text(
                            "Please tap on an element from the left screen 😃",
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                      )
                    : detailsScreen,
              ],
            )
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        detailsScreen = Container(
                          //width: width * .7,
                          padding: EdgeInsets.all(10),
                          height: height,
                          child: Container(
                            width: width,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image.network(
                                          articles[index]['urlToImage'],
                                          //height: height * .5,
                                          width: width,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      articles[index]['title'],
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      articles[index]['content'],
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        var nextScreen = Scaffold(
                          appBar: AppBar(
                            title: Text(articles[index]['title']),
                            backgroundColor: Colors.red,
                          ),
                          body: detailsScreen,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => nextScreen),
                        );
                      });
                    },
                    child: Material(
                      elevation: 4,
                      borderOnForeground: true,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          width: 100,
                          color: Colors.yellow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(articles[index]['urlToImage']),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(articles[index]['title']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
