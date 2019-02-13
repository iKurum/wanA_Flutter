import 'package:flutter/material.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/pages/ArticleDetailPage.dart';
import 'package:zafkiel/pages/LoginPage.dart';
import 'package:zafkiel/util/DataUtils.dart';
import 'package:zafkiel/util/StringUtils.dart';

class ArticleItem extends StatefulWidget {
  var itemData;

  //是否来自搜索列表
  bool isSearch;
  //搜索列表id
  String id;

  ArticleItem(var itemData) {
    this.itemData = itemData;
    this.isSearch = false;
  }

  //命名构造函数
  ArticleItem.isFromSearch(var itemData, String id) {
    this.itemData = itemData;
    this.isSearch = true;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() {
    return ArticleItemState();
  }
}

class ArticleItemState extends State<ArticleItem> {
  void _handleOnItemCollect(itemData) {
    DataUtils.isLogin().then((isLogin) {
      if (!isLogin) {
        _login();
      } else {
        _itemCollect(itemData);
      }
    });
  }

  _login() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  void _itemClick(itemData) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(
        title: itemData['title'],
        url: itemData['link'],
      );
    }));
  }

  //收藏/取消收藏
  void _itemCollect(var itemData) {
    String url;
    if (itemData['collect']) {
      url = Api.UNCOLLECT_ORIGINID;
    } else {
      url = Api.COLLECT;
    }
    url += '${itemData["id"]}/json';
    HttpUtil.post(url, (data) {
      setState(() {
        itemData['collect'] = !itemData['collect'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCollect = widget.itemData['collect'];

    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text('作者：'),
            Text(
              widget.itemData['author'],
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        )),
        Text(widget.itemData['niceDate'])
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text.rich(
            widget.isSearch
                ? StringUtils.getTextSpan(widget.itemData['title'], widget.id)
                : TextSpan(text: widget.itemData['title']),
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.isSearch ? '' : widget.itemData['chapterName'],
            softWrap: true,
            style: TextStyle(color: Theme.of(context).accentColor),
            textAlign: TextAlign.left,
          ),
        ),
        GestureDetector(
          child: Icon(
            isCollect ? Icons.favorite : Icons.favorite_border,
            color: isCollect ? Colors.red : null,
          ),
          onTap: () {
            _handleOnItemCollect(widget.itemData);
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
          _itemClick(widget.itemData);
        },
      ),
    );
  }
}
