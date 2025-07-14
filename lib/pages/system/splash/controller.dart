import 'package:get/get.dart';
import 'package:template/common/index.dart';

class SplashController extends GetxController {
  SplashController();

  _initData() {
    update(["splash"]);
  }

  void onTap() {}


  @override
  void onInit() {
    super.onInit();

    // 设置系统样式
    AppTheme.setSystemStyle();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
