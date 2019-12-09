// const serviceUrl = 'http://rap2api.taobao.org/app/mock/237888/wxmini/';
// const servicePath = {
//   'homePageContent': serviceUrl + 'index', // 商店首页信息
//   'homePageBelowContent': serviceUrl + 'belowContent', // 首页火爆专区--下拉刷新
//   'getCategory': serviceUrl + 'category', // 分类信息
//   'getMallGoods': serviceUrl + 'getMallGoods', // 商品分类的商品列表
// };


const serviceUrl = 'http://v.jspang.com:8088/baixing/'; 
const servicePath = {
   'homePageContent':serviceUrl + 'wxmini/homePageContent', // 商店首页信息
   'homePageBelowContent':serviceUrl + 'wxmini/homePageBelowConten', // 首页热卖商品
   'getCategory':serviceUrl + 'wxmini/getCategory',  // 商品类别信息
   'getMallGoods':serviceUrl + 'wxmini/getMallGoods',  // 商品分类页面商品列表
   'getGoodDetailById':serviceUrl + 'wxmini/getGoodDetailById',  // 商品详情
};