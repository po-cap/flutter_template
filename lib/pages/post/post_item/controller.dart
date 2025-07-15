import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostItemController extends GetxController {
  PostItemController();

  /// 已選中的圖片
  List<AssetEntity> selectedAssets = [];

  /// 是否正在拖曳
  bool isDragging = false;

  String assetTargetId= "";

  _initData() {
    update(["post_item"]);
  }

  void onTap() {}

  void onSelectAssets() async {
    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        maxAssets: 9,
        requestType: RequestType.image,
      ),
    );

    selectedAssets = result ?? [];

    update(["post_item"]);
  }

  void onRemoveAsset(AssetEntity asset) {
    selectedAssets.remove(asset);
    update(["post_item"]);
  }

  void onSwapAssets(AssetEntity fromAsset, AssetEntity toAsset) {
    final fromIdx = selectedAssets.indexOf(fromAsset);
    final toIdx   = selectedAssets.indexOf(toAsset);

    final tmp = selectedAssets[fromIdx];
    selectedAssets[fromIdx] = selectedAssets[toIdx];
    selectedAssets[toIdx] = tmp;
    update(["post_item"]);
  }

  void onSetTargetId(String id) {
    assetTargetId = id;
    debugPrint('ID = $id');
    update(["post_item"]);
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
