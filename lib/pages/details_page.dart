import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import './../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabber.dart';
import './details_page/details_web.dart';
import './details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // flutter自带icon UI
          onPressed: (){
            Navigator.pop(context); // 返回上一层
          },
        ),
        title: Text('商品详情'),
      ),
      body: FutureBuilder(
        future: _getGoodsInfo(context),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Container(
                  
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        DetailsTopArea(),
                        DetailsExplain(),
                        DetailsTabber(),
                        DetailsWeb()
                      ],
                    ),
                  )
                  
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: DetailsBottom(),
                )
              ],
            );
            
          } else {
            return Text('加载中');
          }
        },
      ),
    );
  }

  Future _getGoodsInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '加载完成';
  }
}