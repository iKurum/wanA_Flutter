import 'package:flutter/material.dart';
import 'package:zafkiel/constant/Constants.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/item/ArticleItem.dart';
import 'package:zafkiel/widget/EndLine.dart';

class ArticleListPage extends StatefulWidget {
  final String id;
  ArticleListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int curPage = 0;
  Map<String, String> map = Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getArticleList();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getArticleList();
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
        key: PageStorageKey(widget.id),
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    _getArticleList();
    return null;
  }

  Widget buildItem(int i) {
    var itemData = listData[i];

    if (i == listData.length - 1 &&
        itemData.toString() == Constants.endLineTag) {
      return EndLine();
    }

    return ArticleItem(itemData);
  }

  void _getArticleList() {
    String url = Api.ARTICLE_LIST;
    url += '$curPage/json';
    map['cid'] = widget.id;

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
          if (list.length > listTotalSize) {
            list.add(Constants.endLineTag);
          }
          listData = list;
        });
      }
    }, params: map);
  }
}
