import 'package:get/get.dart';
import 'package:template/common/index.dart';

class SplashController extends GetxController {
  SplashController();

  //_jumpToPage() {
  //  // 欢迎页
  //  Future.delayed(const Duration(seconds: 1), () {
  //    Get.offAllNamed(RouteNames.systemWelcome);
  //  });
  //}


  /// 跳转页面
  _jumpToPage() {
    // 延迟1秒
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      // 是否已打开
      if (await ConfigService.to.isAlreadyOpen) {
        // 跳转首页
        Get.offAllNamed(RouteNames.systemMain);
      } else {
        // 跳转欢迎页
        Get.offAllNamed(RouteNames.systemWelcome);
      }
    });
  }



  @override
  void onInit() {
    super.onInit();

    // 设置系统样式
    AppTheme.setSystemStyle();
  }

  @override
  void onReady() {
    super.onReady();
    // _initData(); // 初始数据
    _jumpToPage(); // 跳转界面
  }


}
