import 'package:flutter/material.dart';
import 'package:zafkiel/constant/Constants.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/item/ArticleItem.dart';
import 'package:zafkiel/widget/EndLine.dart';
import 'package:zafkiel/widget/SlideView.dart';

class HomeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeListPageState();
  }
}

class HomeListPageState extends State<HomeListPage> {
  List listData = List();
  var bannerData;
  var curPage = 0;
  var listTotalSize = 0;

  ScrollController _controller = ScrollController();
  TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  TextStyle subtitleTextStyle = TextStyle(color: Colors.blue, fontSize: 12.0);

  HomeListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        getHomeArticlelist();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticlelist();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    getBanner();
    getHomeArticlelist();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length + 1,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  SlideView _bannerView;

  void getBanner() {
    String bannerUrl = Api.BANNER;

    HttpUtil.get(bannerUrl, (data) {
      if (data != null) {
        setState(() {
          bannerData = data;
          _bannerView = SlideView(bannerData);
        });
      }
    });
  }

  void getHomeArticlelist() {
    String url = Api.ARTICLE_LIST;
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
    });
  }

  Widget buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180.0,
        child: _bannerView,
      );
    }
    i -= 1;

    var itemData = listData[i];
    if (itemData is String && itemData == Constants.endLineTag) {
      return EndLine();
    }

    return ArticleItem(itemData);
  }
}
