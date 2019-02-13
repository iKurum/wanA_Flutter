import 'dart:convert';

import 'package:zafkiel/http/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HttpUtil {
  static const String GET = "get";
  static const String POST = "post";

  static void get(String url, Function callback,
      {Map<String, String> params,
      Map<String, String> headers,
      Function errorCallback}) async {
    if (!url.startsWith('http')) {
      url = Api.BaseUrl + url;
    }

    if (params != null && params.isNotEmpty) {
      StringBuffer s = StringBuffer('?');
      params.forEach((key, value) {
        s.write('$key=$value&');
      });
      String paramStr = s.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }

    await _request(url, callback,
        method: GET, headers: headers, errorCallback: errorCallback);
  }

  static void post(String url, Function callback,
      {Map<String, String> params,
      Map<String, String> headers,
      Function errorCallback}) async {
    if (!url.startsWith('http')) {
      url = Api.BaseUrl + url;
    }

    await _request(url, callback,
        method: POST, headers: headers, errorCallback: errorCallback);
  }

  static Future _request(String url, Function callback,
      {String method,
      Map<String, String> params,
      Map<String, String> headers,
      Function errorCallback}) async {
    String errorMsg;
    int errorCode;
    var data;
    try {
      Map<String, String> headerMap = headers == null ? Map() : headers;
      Map<String, String> paramMap = params == null ? Map() : params;

      //统一添加cookie
      SharedPreferences sp = await SharedPreferences.getInstance();
      String cookie = sp.get('cookie');
      if (cookie == null || cookie.length == 0) {
      }else {
        headerMap['cookie'] = cookie;
      }

      http.Response res;
      if (POST == method) {
        print('POST:URL=' + url);
        print('POST:BODY=' + paramMap.toString());
        res = await http.post(url, headers: headerMap, body: paramMap);
      } else {
        print('GET:URL=' + url);
        res = await http.get(url, headers: headerMap);
      }

      if (res.statusCode != 200) {
        errorMsg = "网络请求错误，状态码：" + res.statusCode.toString();
        _handError(errorCallback, errorMsg);
        return;
      }

      //业务需求封装
      Map<String, dynamic> map = json.decode(res.body);

      errorCode = map['errorCode'];
      errorMsg = map['errorMsg'];
      data = map['data'];

      //保存登陆接口的cookie
      if (url.contains(Api.LOGIN)) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('cookie', res.headers['set-cookie']);
      }

      if (callback != null) {
        if (errorCode >= 0) {
          callback(data);
        } else {
          _handError(errorCallback, errorMsg);
        }
      }
    } catch (exception) {
      _handError(errorCallback, exception.toString());
    }
  }

  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print('errorMsg: ' + errorMsg);
  }
}
