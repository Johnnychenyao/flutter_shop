import 'package:dio/dio.dart';  // 与后端数据交流
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 获取首页主题内容
Future request(url, {formData}) async{ // {} 可选参数
  try {
    print('开始获取数据.........');
    Response response;
    Dio dio = new Dio();
    // dio.options.contentType = ContentType.parse("application/json");
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    // response = formData == null ? await dio.post(servicePath[url]) : await dio.post(servicePath[url], data: formData);
    if (response.statusCode == 200) { // 判断接口是否正常
      return response.data;
    } else { // 不正常，抛出错误
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print('ERROR:==========>${e}');
  }
}
