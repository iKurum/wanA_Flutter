import 'package:flutter/material.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/pages/ArticleDetailPage.dart';
import 'package:zafkiel/pages/SearchPage.dart';

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HotPageState();
  }
}

class HotPageState extends State<HotPage> {
  List<Widget> hotkeyWidgets = List();
  List<Widget> friendWidgets = List();

  @override
  void initState() {
    super.initState();

    _getFriend();
    _getHotkey();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('大家都在搜',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0)),
        ),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: hotkeyWidgets,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('常用网站',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0)),
        ),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: friendWidgets,
        ),
      ],
    );
  }

  void _getFriend() {
    HttpUtil.get(Api.FRIEND, (data) {
      setState(() {
        List datas = data;
        friendWidgets.clear();
        for (var itemData in datas) {
          Widget actionChip = ActionChip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                itemData['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                itemData['title'] = itemData['name'];
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ArticleDetailPage(
                      title: itemData['title'], url: itemData['link']);
                }));
              });

          friendWidgets.add(actionChip);
        }
      });
    });
  }

  void _getHotkey() {
    HttpUtil.get(Api.HOTKEY, (data) {
      setState(() {
        List datas = data;
        hotkeyWidgets.clear();
        for (var value in datas) {
          Widget actionChip = ActionChip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                value['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return SearchPage(value['name']);
                }));
              });

          hotkeyWidgets.add(actionChip);
        }
      });
    });
  }
}
