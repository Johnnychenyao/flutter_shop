import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 右侧小类高亮索引
  int categoryIndex = 0; // 大类索引
  String categoryId = '4'; // 左侧大类id,初始：“白酒”id
  String subId = ''; // 右侧小类id
  int page = 1; // 页码
  String noMoreText = ''; //显示没有数据的文字

  // 左侧大类切换逻辑
  getChildCategory(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = '';
    childIndex = 0;
    categoryId = id;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners(); // 更新状态
  }

  // 右侧小类切换索引
  changeChildIndex(index, String id) {
    page = 1;
    noMoreText = '';
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  // 增加Page的方法
  addPage() {
    page++;
  }

  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
  
  //首页点击类别是更改类别
  changeCategory(String id,int index){
      categoryId=id;
      categoryIndex=index;
      subId ='';
      notifyListeners();
  }
}