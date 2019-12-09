// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// // 动态组件
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // 创建输入文本框
//   TextEditingController typeController = TextEditingController();
//   String showText = '欢迎来到美好人间';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('美好人间'),),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             // 输入文本框
//             TextField(
//               controller: typeController,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(10.0),
//                 labelText: '美女类型',
//                 helperText: '请输入你喜欢的类型'
//               ),
//               autofocus: false,
//             ),
//             RaisedButton(
//               onPressed: (){
//                 _choiceAction();
//               },
//               child: Text('选择完成'),
//             ),
//             Text(
//               showText,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _choiceAction() {
//     if (typeController.text.toString() == '') {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(title: Text('输入不能为空！！！'),)
//       );
//     } else {
//       getHttp(typeController.text.toString()).then((val){
//         setState(() {
//           showText = val['data']['msg'].toString();
//         });
//       });
//     }
//   }

//   Future getHttp(String TypeText) async {
//     try {
//       Response response;
//       var data = {'name': TypeText};
//       response = await Dio().get('http://rap2api.taobao.org/app/mock/237888/test',
//         queryParameters: data
//       );
//       return response.data;
//     } catch (e) {
//       return print(e);
//     }
//   }
// }
