import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo.goodsDetail;

    return Provide<DetailsInfoProvide>(
      builder: (context, child, val){
        bool isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;

        if (isLeft) {
          return Container(
            // child: SingleChildScrollView(
              child: Html(
                data: goodsDetails
              ),
            // )
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text(
              '暂无数据'
            ),
          );
        }

      },
    );
    
  }
}