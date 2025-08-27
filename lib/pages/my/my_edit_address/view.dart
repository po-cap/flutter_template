import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MyEditAddressPage extends GetView<MyEditAddressController> {
  const MyEditAddressPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("MyEditAddressPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyEditAddressController>(
      init: MyEditAddressController(),
      id: "my_edit_address",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("my_edit_address")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
