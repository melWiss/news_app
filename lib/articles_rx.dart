import 'package:news_app/news_element.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';
import 'news_element.dart';
import 'db.dart';

class ListArticles {
  BehaviorSubject _listArticles =
      BehaviorSubject<List<NewsElement>>.seeded(<NewsElement>[]);
  BehaviorSubject _index = BehaviorSubject.seeded(-1);

  Stream get stream$ => _listArticles.stream;
  List<NewsElement> get current => _listArticles.value;

  Stream get indexStream$ => _index.stream;
  int get currentIndex => _index.value;

  List<NewsElement> _localNews = [];
  List<NewsElement> _apiNews = [];

  int _localNewsIndex = -1;
  int _apiNewsIndex = -1;

  localNewsIndex(int index) {
    _localNewsIndex = index;
  }

  apiNewsIndex(int index) {
    _apiNewsIndex = index;
  }

  Future apiArticles() async {
    Api api = Api();
    var articles = await api.getNews();
    _apiNews = articles;
  }

  Future localArticles() async {
    var localDB = await getData();
    var newsList = List.generate(
      localDB.length,
      (index) => NewsElement.fromMap(localDB[index]),
    );
    _localNews = newsList;
  }

  Future articlesProviderSelector(int index) async {
    switch (index) {
      case 0:
        _listArticles.add(_apiNews);
        _index.add(_apiNewsIndex);
        break;
      case 1:
        await localArticles();
        _listArticles.add(_localNews);
        _index.add(_localNewsIndex);
        break;
      default:
        _listArticles.add(_apiNews);
        _index.add(_apiNewsIndex);
    }
  }
}
