import 'package:flutter/material.dart';
import 'package:zafkiel/constant/Constants.dart';
import 'package:zafkiel/event/LoginEvent.dart';
import 'package:zafkiel/pages/AboutUsPage.dart';
import 'package:zafkiel/pages/CollectListPage.dart';
import 'package:zafkiel/pages/LoginPage.dart';
import 'package:zafkiel/util/DataUtils.dart';

class MyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> {
  String userName;

  @override
  void initState() {
    super.initState();
    _getName();

    Constants.eventBus.on<LoginEvent>().listen((event) {
      _getName();
    });
  }

  void _getName() async {
    DataUtils.getUserName().then((username) {
      setState(() {
        userName = username;
        print('name: ' + userName.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'img/zafkiel.png',
      width: 100.0,
      height: 100.0,
    );

    Widget raiseButton = RaisedButton(
      child: Text(
        userName == null ? '请登录' : userName,
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).accentColor,
      onPressed: () async {
        await DataUtils.isLogin().then((isLogin) {
          if (!isLogin) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          } else {
            print('已登录');
          }
        });
      },
    );

    Widget listLike = ListTile(
      leading: const Icon(Icons.favorite),
      title: const Text('喜欢的文章'),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: () async {
        await DataUtils.isLogin().then((isLogin) {
          if (isLogin) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return CollectPage();
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          }
        });
      },
    );

    Widget listAbout = ListTile(
      leading: const Icon(Icons.info),
      title: const Text('关于'),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AboutUsPage();
        }));
      },
    );

    Widget listLogout = ListTile(
      leading: const Icon(Icons.info),
      title: const Text('退出登陆'),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: () async {
        DataUtils.clearLoginInfo();
        setState(() {
          userName = null;
        });
      },
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      children: <Widget>[
        image,
        raiseButton,
        listLike,
        listAbout,
        listLogout,
      ],
    );
  }
}
