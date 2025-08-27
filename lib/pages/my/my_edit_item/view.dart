import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MyEditItemPage extends GetView<MyEditItemController> {
  const MyEditItemPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("MyEditItemPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyEditItemController>(
      init: MyEditItemController(),
      id: "my_edit_item",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("my_edit_item")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
