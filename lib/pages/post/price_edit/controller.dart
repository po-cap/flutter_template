import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';




class PriceEditController extends GetxController {
  PriceEditController();

  /// “價格” 輸入控制器
  final priceController = TextEditingController();

  /// “數量” 輸入控制器
  final quantityController = TextEditingController();

  _initData() {
    update(["price_edit"]);
  }

  void onTap() {}

  void onSetSkuPrice(SkuModel? sku) {

    final price    = double.tryParse(priceController.text);
    final quantity = int.tryParse(quantityController.text);

    if(price == null || quantity == null) {
      Loading.toast("必須設定價格與數量");
      return;
    }

    priceController.clear();
    quantityController.clear();

    if(sku == null) {
      final skus = Get.find<PostItemController>().skus;
      skus.add(
        SkuModel(
          id: 0, 
          name: "", 
          spec: {}, 
          price: price, 
          quantity: quantity
        )
      );
    }
    else {
      sku.price = price;
      sku.quantity = quantity;
    }

    Get.back();
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

  @override
  void onClose() {
    super.onClose();
    priceController.dispose();
    quantityController.dispose();
  }
}
