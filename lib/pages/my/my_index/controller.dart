import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MyIndexController extends GetxController {
  MyIndexController();

  /// 滚动控制器
  ScrollController scrollController = ScrollController();

  /// 是否滚动
  bool isScrolled = false;

  _initData() {
    update(["my_index"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      isScrolled = scrollController.offset > 10;
      update(["my_index"]);
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  Future onChangeBanner() async {
    final assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    if(assets == null || assets.isEmpty) return;

    final bannerUrl = await PostApi.uploadImage(assets.first);
  
    final profile = UserService.to.profile.copyWith(
      banner: bannerUrl
    );

    await UserService.to.setProfile(profile);

    update(["my_index"]);
  }

   // 注销
  void onLogout() {
    UserService.to.logout();
    Get.find<MainController>().onJumpToPage(0);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
