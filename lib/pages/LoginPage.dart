import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _nameContro = TextEditingController(text: 'zafkiel');
  TextEditingController _passwordContro =
      TextEditingController(text: 'w123456');
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    Row avatar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.account_circle,
          color: Theme.of(context).accentColor,
          size: 80.0,
        ),
      ],
    );

    TextField name = TextField(
      autofocus: true,
      decoration: InputDecoration(labelText: '用户名'),
      controller: _nameContro,
    );

    TextField password = TextField(
      decoration: InputDecoration(labelText: '密码'),
      obscureText: true,
      controller: _passwordContro,
    );

    Row loginAndRegister = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          child: Text('登陆', style: TextStyle(color: Colors.white)),
          color: Theme.of(context).accentColor,
          disabledColor: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            _login();
          },
        ),
        RaisedButton(
          child: Text('注册', style: TextStyle(color: Colors.white)),
          color: Colors.blue,
          disabledColor: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            _register();
          },
        ),
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('登陆'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
        child: ListView(
          children: <Widget>[
            avatar,
            name,
            password,
            Padding(padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0)),
            loginAndRegister,
          ],
        ),
      ),
    );
  }

  void _login() {}
  void _register() {}
}
