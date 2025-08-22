import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostShortController extends GetxController {
  PostShortController();

  // 内容输入控制器
  final contentController = TextEditingController();

  /// 选择的照片
  List<AssetEntity> assets = [];

  _initData() {
    update(["post_short"]);
  }

  void onTap() {}

  void onAssetsChanged(
    List<AssetEntity> assets
  ) {
    this.assets = assets;
    update(["post_short"]);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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
