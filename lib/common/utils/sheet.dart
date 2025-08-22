

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sheet {

  /// 從底部彈出頁面
  static Future page({
    required Widget child
  }) async {
    await showModalBottomSheet(
      context: Get.context!, 
      isScrollControlled: true,
      enableDrag: false,
      builder:(context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: child
        );        
      },
    );
  }

    /// 從底部彈出選項欄
  static Future pop({
    required Widget child
  }) async {
    await showModalBottomSheet(
      context: Get.context!, 
      isScrollControlled: true,
      enableDrag: false,
      builder:(context) {
        return child;        
      },
    );
  }
}