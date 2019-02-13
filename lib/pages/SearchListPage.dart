import 'package:flutter/material.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/constant/Constants.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/item/ArticleItem.dart';
import 'package:zafkiel/widget/EndLine.dart';

class SearchListPage extends StatefulWidget {
  String id;
  SearchListPage(ValueKey<String> key) : super(key: key) {
    this.id = key.value.toString();
  }

  @override
  State<StatefulWidget> createState() {
    return SearchListPageState();
  }
}

class SearchListPageState extends State<SearchListPage> {
  int curPage = 0;

  Map<String, String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        _articleQuery();
      }
    });

    _articleQuery();
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
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }

  void _articleQuery() {
    String url = Api.ARTICLE_QUERY;
    url += "$curPage/json";
    map['k'] = widget.id;

    HttpUtil.post(url, (data) {
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

  Future<Null> pullToRefresh() async {
    curPage = 0;
    _articleQuery();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = listData[i];

    if (i == listData.length - 1 &&
        itemData.toString() == Constants.endLineTag) {
      return EndLine();
    }

    return ArticleItem.isFromSearch(itemData, widget.id);
  }
}
