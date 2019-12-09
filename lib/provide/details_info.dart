import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/detail.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;

  // 获取后台商品数据
  getGoodsInfo(String id) async{
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((val){
      var responseData = json.decode(val.toString());
      print('responseData=>${responseData}');
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

  // tabber的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}