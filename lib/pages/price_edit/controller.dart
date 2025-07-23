import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceEditController extends GetxController {
  PriceEditController();

  /// “價格” 控制器
  final priceController = TextEditingController();
  
  /// “庫存” 控制器
  final quantityController = TextEditingController();

  _initData() {
    update(["price_edit"]);
  }

  void onTap() {}

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
