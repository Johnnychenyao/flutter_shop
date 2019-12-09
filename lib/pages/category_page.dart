import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(title: Text('商品分类'),),
        body: Container(
          child: Row(
            children: <Widget>[
              LeftCategoryNav(),
              Column(
                children: <Widget>[
                  RightCategoryNavState(),
                  CategoryGoodsList()
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];
  int listIndex = 0; // 索引

  @override
  void initState() { 
    _getCategory();
    super.initState();
    // _getCategoryGoods();
  }

  @override
  Widget build(BuildContext context) {

    return Provide<ChildCategory>(
      builder: (context, child, val){
        _getCategoryGoods(context); // 首次点击导航“分类”，展示数据
        listIndex = val.categoryIndex;
        return Container(
          width: ScreenUtil().setWidth(180),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1,color: Colors.black12)
            )
          ),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return _leftInkWell(index);
            },
          ),
        );
      },
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: (){
        // 点击左侧大类选项，获取右侧小类列表，通过provide传递数据
        // setState(() {
        //   listIndex = index; 
        // });
        var childCategory = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childCategory, categoryId);
        Provide.value<ChildCategory>(context).changeCategory(categoryId,index);
        _getCategoryGoods(context, categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12
            )
          )
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  // 获取数据
  void _getCategory() async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      // list.data.forEach((item)=>print(item.mallCategoryName));
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  // 获取数据 -- 切换左侧大类获取商品列表
  void _getCategoryGoods(context, {String categoryId}) async{
     
    var data={
      'categoryId':categoryId==null?Provide.value<ChildCategory>(context).categoryId:categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':1
    };

    await request('getMallGoods', formData: data).then((val){
      var  data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

// 右侧小类导航
class RightCategoryNavState extends StatefulWidget {
  @override
  _RightCategoryNavStateState createState() => _RightCategoryNavStateState();
}

class _RightCategoryNavStateState extends State<RightCategoryNavState> {

  // List list = ['全部', '分类1', '分类2', '分类3', '分类1', '分类1', '分类1', '分类1', '分类8', '分类8', '分类8', '分类8', '分类8'];  // 测试数据

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>( // 接受provide传递过来的数据
      builder: (context, child, childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12) 
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index){
              return _rightInkWell(index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  // 小分类单个选项
  Widget _rightInkWell(int index, BxMallSubDto item){
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true :false;

    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index, item.mallSubId);
        _getCategoryGoods(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28), 
            color: isClick?Colors.pink:Colors.black
          ),
        ),
      ),
    );
  }

  // 获取数据 -- 分类商品列表信息
  void _getCategoryGoods(String categorySubId) async{
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };

    await request('getMallGoods', formData: data).then((val){
      var  data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
        print(Provide.value<CategoryGoodsListProvide>(context).goodsList);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }
}

// 分类商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scorllController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data){
        print('data.goodsList=>${data.goodsList}');
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            scorllController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化：${e}');
        }

        if (data.goodsList.length > 0) {
          return Expanded( // 类似弹性高度--flexible 无需设置高度
            child: Container(
              width: ScreenUtil().setWidth(570),
              // height: ScreenUtil().setHeight(1443),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key:_footerKey,
                  bgColor:Colors.white,
                  textColor:Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore:true,
                  noMoreText:Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo:'加载中',
                  loadReadyText:'上拉加载'
                ),
                child: ListView.builder(
                  controller: scorllController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _listWidget(data.goodsList, index);
                  },
                ),
                loadMore: () {
                  if (Provide.value<ChildCategory>(context).noMoreText=='没有更多了') {
                    Fluttertoast.showToast(
                      msg: '已经到底了',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.pink,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  } else {
                    _getMoreList();
                  }
                },
              )
            ),
          );
        } else {
          return Text('暂无数据');
        }
      },
    );
  }

  // 上拉加载更多方法
  void _getMoreList() async{
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    await request('getMallGoods', formData: data).then((val){
      var  data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context).addGoodsList(goodsList.data);
      }
    });
  }

  // 分类商品小组件--图片
  Widget _goodsImage(List list, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  // 分类商品小组件--标题
  Widget _goodsName(List list,index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
        ),
      ),
    );
  }

  // 分类商品小组件--价格
  Widget _goodsPrice(List list, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${list[index].presentPrice}',
            style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  // 组合小组件
  Widget _listWidget(List list, index) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color:  Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(list, index),
            Column(
              children: <Widget>[
                _goodsName(list, index),
                _goodsPrice(list, index)
              ],
            )
          ],
        ),
      )
    );
  }
}