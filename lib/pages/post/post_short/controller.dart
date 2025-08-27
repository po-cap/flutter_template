import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/components/skus.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostShortController extends GetxController {
  PostShortController();

  // 内容输入控制器
  final contentController = TextEditingController();

  // 聚焦
  final focusNode = FocusNode();

  /// 选择的照片
  List<AssetEntity> assets = [];

  /// 庫存單元
  List<SkuModel> skus = [];

  /// 銷售屬性
  Map<String, List<String>> salesAttributes = {};

  _initData() {

    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        update(["post_short"]);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    contentController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void onEditSalesAttributes() async {

    await ActionBottomSheet.barModel(
      SalesAttributesWidget(
        salesAttributes: salesAttributes,
        onAttributesChanged: (val) {
          salesAttributes = val;
          update(["post_short"]);
        },
        onSkusChanged: (val) {
          skus = val;
          update(["post_short"]);
        },
      )
    );
  }

  void onEditPrice() async {
    late Widget ws;
    
    if(skus.isEmpty) {
      ws = PriceWidget(
        onSkuChanged: (sku) {
          skus.add(sku);
          update(["post_short"]);
        }
      );
    } else if(skus.length == 1) {
      ws = PriceWidget(
        sku: skus[0],
        onSkuChanged: (sku) {
          skus[0] = sku;
          update(["post_short"]);
        }
      );
    } else {
      ws = SkusWidget(
        skus: skus, 
        onSkusChanged: (val) {
          skus = val;
          update(["post_short"]);
        }
      );
    }
    await ActionBottomSheet.barModel(ws);
  }

  void onAssetsChanged(
    List<AssetEntity> assets
  ) {
    this.assets = assets;
    update(["post_short"]);
  }

  void onConfirm() async {

    Loading.show();
    try{
      await PostApi.add(
        description: contentController.text,
        album: assets,
        skus: skus
      );
      Get.back();
    } finally {
      Loading.dismiss();
    }
  }

  void onUnFocus() {
    focusNode.unfocus();
    update(["post_short"]);
  }
}
