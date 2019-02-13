import 'package:flutter/material.dart';
import 'package:zafkiel/http/Api.dart';
import 'package:zafkiel/http/HttpUtilWithCookie.dart';
import 'package:zafkiel/pages/ArticlesPage.dart';

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TreePageState();
  }
}

class TreePageState extends State<TreePage> {
  var listData;

  @override
  void initState() {
    super.initState();
    _getTree();
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, i) => buildItem(i),
      );
      return listView;
    }
  }

  Widget buildItem(int i) {
    var itemData = listData[i];

    Text name = Text(
      itemData['name'],
      softWrap: true,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );

    List list = itemData['children'];
    String strContent = '';
    for (var value in list) {
      strContent += '${value["name"]}';
    }

    Text content = Text(
      strContent,
      softWrap: true,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.left,
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          _handOnItemClick(itemData);
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: name,
                    ),
                    content,
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getTree() async {
    HttpUtil.get(Api.TREE, (data) {
      setState(() {
        listData = data;
      });
    });
  }

  void _handOnItemClick(itemData) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticlesPage(itemData);
    }));
  }
}
