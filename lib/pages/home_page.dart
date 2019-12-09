import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import './../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int page = 1; // 火爆专区页码
  List<Map> hotGoodsList = [];
  String homePageContent = '正在获取数据';
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    // _getHotGoods();
  }

  @override
  bool get wantKeepAlive => true; // 缓存页面，切换时不重新加载

  @override
  Widget build(BuildContext context) {
    // 设备像素密度
    // print('设备像素密度:${ScreenUtil.pixelRatio}');
    // print('设备的高:${ScreenUtil.screenWidth}');
    // print('设备的宽:${ScreenUtil.screenHeight}');

    var formData = { 'lon': '115.02932', 'lat': '35.76189' };
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: FutureBuilder( // FutureBuilder--异步加载
        future: request('homePageContent', formData: formData),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString()); // 字符串转json，json格式化
            // var data = snapshot.data; //返回的数据已经是json
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String adBanner = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast();

            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中...',
                loadReadyText: '上拉加载😝',
              ),
              child: ListView( // 单页面优化滚动bug
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiper,),
                  TopNavigator(navigatorList: navigatorList,),
                  AdBanner(adPicture: adBanner,),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  _hotGoods()
                ],
              ),
              loadMore: () async{
                var formData = {'page': page};
                await request('homePageBelowContent', formData: formData).then((val) {
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    page++;
                    hotGoodsList.addAll(newGoodsList);
                  });
                });
              },
            );
            
          } else {
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }

  // 获取热销商品数据
  // void _getHotGoods() {  //测试接口
  //   var formData = {'page': page};
  //   request('homePageBelowContent', formData: formData).then((data) {
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       page++;
  //       hotGoodsList.addAll(newGoodsList);
  //     });
  //   });
  // }

  // 热搜商品标题组件
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
    alignment: Alignment.center,
    child: Text(
      '火爆专区',
      style: TextStyle(color: Colors.pink),
    ),
  );

  // 热搜商品流式布局组件
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                        color: Colors.black26, 
                        decoration: TextDecoration.lineThrough, 
                        // fontSize: ScreenUtil().setSp(30)
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap( //流布局
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  // 合拼成火爆专区
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }

}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {

  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context, "/detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: new Image.network('${swiperDataList[index]['image']}',fit:BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}

// 导航
class TopNavigator extends StatelessWidget {

  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}):super(key:key);

  // 单个导航小组件
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(  
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), // 禁止滚动
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告栏
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 电话咨询栏
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async{
    String url = 'tel:' + leaderPhone;
    print(url);
    if (await canLaunch(url)) { // 检测url格式是否合法: sms tel http email
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  // 商品推荐的标题栏方法 --- 拆分成小组件
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft, // 左对齐
      height: ScreenUtil().setHeight(50),
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration( // 盒子模式样式
        color: Colors.white, // 底色
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: Text('商品推荐', style: TextStyle(color: Colors.pink),),
    );
  }

  // 商品单独项方法
  Widget _item(context, index) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, "/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        // height: ScreenUtil().setHeight(410),
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12)
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(380),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, //横向
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return _item(context, index);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: ScreenUtil().setHeight(460),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

// 火爆专区