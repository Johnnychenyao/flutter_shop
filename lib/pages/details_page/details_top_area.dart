import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/details_info.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val){
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if (Provide.value<DetailsInfoProvide>(context).goodsInfo != null) {
          return Container(
            // width: ScreenUtil().setWidth(1080),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNumber(goodsInfo.goodsSerialNumber),
                _goodsPrice(goodsInfo.oriPrice, goodsInfo.presentPrice)
              ],
            ),
          );
        } else {
          return Text('正在加载中...');
        }
      },
    );
    
  }

  // 商品首图
  Widget _goodsImage(url) {
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
    );
  }

  // 商品名称
  Widget _goodsName(name) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }

  // 商品编号
  Widget _goodsNumber(number) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        '编号:${number}',
        style: TextStyle(
          color: Colors.black26
        )
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(double oriPrice, double presentPrice) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            '￥${oriPrice}',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              color: Colors.orangeAccent
            )
          ),
          _goodsPresentPrice(presentPrice)
        ],
      ),
    );
  }

  // 商品价格 -- 市场价
  Widget _goodsPresentPrice(presentPrice) {
    return Container(
      padding: EdgeInsets.only(left: 30.0),
      child: Row(
        children: <Widget>[
          Text(
            '市场价：'
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              '￥${presentPrice}',
              style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough
              ),
            ),
          )
        ],
      ),
    );
  }
}