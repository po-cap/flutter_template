import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class PriceEditPage extends GetView<PriceEditController> {
  
  final SkuModel? sku;

  const PriceEditPage({
    super.key,
    this.sku
  });


  Widget _buildInput() {
    return [
      TextWidget.label("價格"),
      InputWidget(
        keyboardType: TextInputType.number,
        autoClear: true,
      ).paddingBottom(AppSpace.listItem),
      
      TextWidget.label("庫存"),
      InputWidget(
        keyboardType: TextInputType.number,
        autoClear: true,
      ).paddingBottom(AppSpace.listItem),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    );
  }

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: [
        _buildInput()
      ].toColumn()
      .paddingAll(AppSpace.page * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PriceEditController>(
      init: Get.find<PriceEditController>(),
      id: "price_edit",
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TextWidget.h4("設置價格與庫存")
            ),
            body: SafeArea(
              child: _buildView(),
            ),
          ),
        );
      },
    );
  }
}
