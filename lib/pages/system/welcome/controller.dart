import 'package:get/get.dart';
import 'package:template/common/index.dart';

class WelcomeController extends GetxController {
  WelcomeController();

  /// 欢迎数据
  List<WelcomeModel>? items;


  /// 初始化数据
  _initData() {
    items = [
      WelcomeModel(
        image: AssetsImages.welcome_1Png,
        title: LocaleKeys.welcomeOneTitle.tr,
        desc: LocaleKeys.welcomeOneDesc.tr,
      ),
      WelcomeModel(
        image: AssetsImages.welcome_2Png,
        title: LocaleKeys.welcomeTwoTitle.tr,
        desc: LocaleKeys.welcomeTwoDesc.tr,
      ),
      WelcomeModel(
        image: AssetsImages.welcome_3Png,
        title: LocaleKeys.welcomeThreeTitle.tr,
        desc: LocaleKeys.welcomeThreeDesc.tr,
      ),
    ];

    update(["slider"]);
  }

  void onTap() {}

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
