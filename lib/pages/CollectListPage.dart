import 'package:flutter/material.dart';
import 'package:zafkiel/constant/Constants.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/pages/ArticleDetailPage.dart';
import 'package:zafkiel/pages/LoginPage.dart';
import 'package:zafkiel/util/DataUtils.dart';
import 'package:zafkiel/widget/EndLine.dart';

class CollectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('喜欢的文章')),
      body: CollectListPage(),
    );
  }
}

class CollectListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectListPageState();
  }
}

class CollectListPageState extends State<CollectListPage> {
  int curPage = 0;

  Map<String, String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCollectList();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getCollectList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null || listData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      Widget listView = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _getCollectList() {
    String url = Api.COLLECT_LIST;
    url += '$curPage/json';

    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;

        var _listData = map['datas'];
        listTotalSize = map['total'];

        setState(() {
          List list = List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;

          list.addAll(listData);
          list.addAll(_listData);
          if (list.length >= listTotalSize) {
            list.add(Constants.endLineTag);
          }
          listData = list;
        });
      }
    }, params: map);
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    _getCollectList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = listData[i];

    if (i == listData.length - 1 &&
        itemData.toString() == Constants.endLineTag) {
      return EndLine();
    }

    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text('作者：'),
              Text(itemData['author'],
                  style: TextStyle(color: Theme.of(context).accentColor)),
            ],
          ),
        ),
        Text(itemData['niceData'])
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            itemData['title'],
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.favorite, color: Colors.red),
          onTap: () {
            _handleListItemCollect(itemData);
          },
        )
      ],
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: row,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        child: column,
        onTap: () {
          _itemClick(itemData);
        },
      ),
    );
  }

  void _handleListItemCollect(itemData) {
    DataUtils.isLogin().then((isLogin) {
      if (!isLogin) {
        _login();
      } else {
        _itemUnCollect(itemData);
      }
    });
  }

  _login() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  void _itemClick(var itemData) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(title: itemData['title'], url: itemData['link']);
    }));
  }

  void _itemUnCollect(var itemData) {
    String url = Api.UNCOLLECT_LIST;
    url += itemData['id'].toString() + '/json';

    Map<String, String> map = Map();
    map['originId'] = itemData['originId'].toString();

    HttpUtil.post(url, (data) {
      setState(() {
        listData.remove(itemData);
      });
    }, params: map);
  }
}
