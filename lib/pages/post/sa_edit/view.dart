import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'index.dart';

class SaEditPage extends GetView<SaEditController> {
  const SaEditPage({super.key});

  Widget _buildAddPhotoBtn(SalesAttributeValueModel value) {
    return GestureDetector(
      onTap: () => controller.onAddValuePhoto(value),
      child: Icon(Icons.camera_alt)
    );
  }

  Widget _buildPhoto(SalesAttributeValueModel value) {
    return GestureDetector(
      onTap: () => controller.onAddValuePhoto(value),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.image),
        ),
        child: AssetEntityImage(
          value.asset!,
          isOriginal: false,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDeleteValueBtn(
    SalesAttributeModel sa,
    SalesAttributeValueModel value
  ) {
    return GestureDetector(
      onTap: () => controller.onDeleteSAValue(sa, value),
      child: Icon(Icons.delete_outline)
    );
  }

  Widget _buildAttributeValue(
    SalesAttributeModel sa,
    int vauleIdx
  ) {

    final saIdx = controller.salesAttributes.indexOf(sa);

    return [

      /// 銷售屬性照片
      /// 記住，只有第一個銷售屬性到屬性值，可以有照片
      if(saIdx == 0)
      sa.values[vauleIdx].asset == null ?
      _buildAddPhotoBtn(sa.values[vauleIdx]).paddingRight(AppSpace.listRow) :
      _buildPhoto(sa.values[vauleIdx]).paddingRight(AppSpace.listRow),
      
      /// 屬性值名稱
      TextWidget
      .body(sa.values[vauleIdx].value,)
      .expanded(),


      /// 刪除銷售屬性的屬性值
      _buildDeleteValueBtn(sa, sa.values[vauleIdx]),

    ].toRow();
  }

  Widget _buildSalesAttribute(int index) {

    var sa = controller.salesAttributes[index];
    var textController = controller.textControllers[index];

    return [
      
      /// 屬性名稱
      sa.name.isEmpty ? 
      InputWidget(
        controller: textController,  
        placeholder: "添加規格類型",
        onEditingComplete: (name) => controller.onSetSAName(name, index),
        autoClear: true,
        hasBorder: false,
      ) : [
        TextWidget.h4(sa.name),
        GestureDetector(
          onTap: () => controller.onDeleteSA(index),
          child: const Icon(Icons.delete_outline),
        ),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ).paddingAll(AppSpace.card),
    

      /// 屬性值列表
      for(int i = 0; i < sa.values.length; i++)
      _buildAttributeValue(sa, i)
      .paddingAll(AppSpace.card),

      /// 添加屬性值
      if(sa.name.isNotEmpty)
      InputWidget(
        controller: controller.textControllers[index],
        placeholder: "添加屬性值",
        onEditingComplete: (val) => controller.onAddSAValue(sa, val),
        autoClear: true,
      )

    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: [

        // 銷售屬性 widget
        for(int i = 0; i < controller.salesAttributes.length; i++)
        _buildSalesAttribute(i)
        .paddingAll(AppSpace.card)
        .card()
        .paddingBottom(AppSpace.listItem),

        // 添加銷售屬性 button
        if(controller.salesAttributes.length < 2)
        ButtonWidget.ghost(
          "添加規格類型", 
          onTap: () => controller.onAddSA(),
        ).width(double.infinity)
        .padding(
          left: AppSpace.card / 2,
          right: AppSpace.card / 2,
          bottom: AppSpace.listRow * 2,
        ),

      ].toColumn()
      .paddingAll(AppSpace.page),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaEditController>(
      init: Get.find<SaEditController>(),
      id: "sa_edit",
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TextWidget.h4("設定商品規格")
            ),
            body: SafeArea(
              child: _buildView(),
            ),
            bottomSheet: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              child: ButtonWidget.primary(
                  "下一步 設置價格與庫存",
                  onTap: () {},
                ).width(double.infinity)
                .padding(
                  left: AppSpace.card,
                  right: AppSpace.card,
                  bottom: AppSpace.paragraph * 2,
                )
            ),
            resizeToAvoidBottomInset: false
          ),
        );
      },
    );
  }
}
