import 'package:flutter/material.dart';
import 'package:zafkiel/pages/ArticleDetailPage.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutUsPageState();
  }
}

class AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      'img/zafkiel.png',
      width: 100.0,
      height: 100.0,
    );

    return Scaffold(
      appBar: AppBar(title: Text('关于')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        children: <Widget>[
          icon,
          ListTile(
            title: const Text('关于项目'),
            subtitle: const Text('模仿wanAndroid客户端'),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ArticleDetailPage(
                  title: 'wanAndroid Flutter版',
                  //模仿参考代码库地址
                  url: 'https://github.com/canhuah/WanAndroid',
                );
              }));
            }),
            ListTile(
              title: const Text('关于我'),
              subtitle: const Text('出血Flutter'),
              trailing: Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
            ),
        ],
      ),
    );
  }
}
