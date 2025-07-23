import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SkuEditPage extends GetView<SkuEditController> {
  const SkuEditPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("SkuEditPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SkuEditController>(
      init: Get.find<SkuEditController>(),
      id: "sku_edit",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("sku_edit")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
