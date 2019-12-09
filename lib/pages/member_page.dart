import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList()
        ],
      )
    );
  }

  // 优惠头像
  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            child: ClipOval(
              child: Image.network(
                'http://chen.boguanweb.com/bmee/images/RU.png',
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(180),
                height: ScreenUtil().setHeight(150),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'J.cHen',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.black54
              ),
            ),
          )
        ],
      ),
    );
  }

  // 我的订单
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.format_list_bulleted),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  // 
  Widget _orderType() {
    return Container(
      margin:EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(top: 10),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(100),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _orderTypeItem(Icons.query_builder, '待付款'),
          _orderTypeItem(Icons.query_builder, '待发货'),
          _orderTypeItem(Icons.query_builder, '待收货'),
          _orderTypeItem(Icons.query_builder, '已完成')
        ],
      ),
    );
  }

  Widget _orderTypeItem(icon, name) {
    return Container(
      width: ScreenUtil().setWidth(187),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 30
          ),
          Text('${name}')
        ],
      ),
    );
  }

  // 通用ListTile

  Widget _myListTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
  
  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券'),
          _myListTile('领取优惠券'),
          _myListTile('领取优惠券'),
          _myListTile('领取优惠券'),
        ],
      ),
    );
  }

}