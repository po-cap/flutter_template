import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class SaEditPage extends GetView<SaEditController> {
  const SaEditPage({super.key});

  Widget _buildPhoto(
    SalesOptionModel option,
    int valueIdx
  ) {
    return GestureDetector(
      onTap: () => controller.onAddValuePhoto(option, valueIdx),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.image),
        ),
        child: option.values[valueIdx].url != null ? 
        ImageWidget.img(
          option.values[valueIdx].url!, 
          fit: BoxFit.cover, 
          width: 30, 
          height: 30,
        ):
        const Icon(
          Icons.camera_alt,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildDeleteValueBtn(
    SalesOptionModel sa,
    SalesOptionValueModel value
  ) {
    return GestureDetector(
      onTap: () => controller.onDeleteSAValue(sa, value),
      child: Icon(Icons.delete_outline)
    );
  }

  Widget _buildOptionValue(
    SalesOptionModel sa,
    int vauleIdx
  ) {

    return [

      /// 銷售屬性照片
      _buildPhoto(sa, vauleIdx)
      .paddingRight(AppSpace.listRow),

      /// 屬性值名稱
      TextWidget
      .body(sa.values[vauleIdx].name,)
      .expanded(),


      /// 刪除銷售屬性的屬性值
      _buildDeleteValueBtn(sa, sa.values[vauleIdx]),

    ].toRow();
  }

  Widget _buildOption(int index) {

    var sa = controller.options[index];
    var textController = controller.options[index].textController;

    return [
      
      /// 屬性名稱
      sa.name.isEmpty ? 
      InputWidget(
        controller: textController,  
        placeholder: "添加規格類型",
        onEditingComplete: (name) => controller.onSetName(index),
        autoClear: true,
        hasBorder: false,
      ) : [
        TextWidget.h4(sa.name),
        GestureDetector(
          onTap: () => controller.onDeleteOption(index),
          child: const Icon(Icons.delete_outline),
        ),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ).paddingAll(AppSpace.card),
    

      /// 屬性值列表
      for(int i = 0; i < sa.values.length; i++)
      _buildOptionValue(sa, i)
      .paddingAll(AppSpace.card),

      /// 添加屬性值
      if(sa.name.isNotEmpty)
      InputWidget(
        controller: controller.options[index].textController,
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
        for(int i = 0; i < controller.options.length; i++)
        _buildOption(i)
        .paddingAll(AppSpace.card)
        .card()
        .paddingBottom(AppSpace.listItem),

        // 添加銷售屬性 button
        if(controller.options.length < 2)
        ButtonWidget.ghost(
          "添加規格類型", 
          onTap: () => controller.onAddOption(),
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
              title: TextWidget.h4("設定商品規格"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => controller.onCloseEditor()
              ),
            ),
            body: SafeArea(
              child: _buildView(),
            ),
            bottomSheet: SheetButtonWidget(
              onTap: () => controller.onToSKUEditPage(),
              text: "下一步 設置價格與庫存",
              withBackNav: true
            ),
            resizeToAvoidBottomInset: false
          ),
        );
      },
    );
  }
}
