import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

/// 底部按鈕
/// 使用場景：設定銷售屬性，付款等頁面，確認按鈕需要在底部持續出現
class SheetButtonWidget extends StatelessWidget {

  /// 按鈕事件
  final Function()? onTap;
  
  /// 按鈕文字
  final String text;

  /// 是否顯示返回按鈕
  final bool withBackNav;
  
  const SheetButtonWidget({
    super.key,
    required this.onTap,
    required this.text,
    this.withBackNav = false
  });

  
  Widget _buildView() {
    return <Widget>[
      if(withBackNav)
      ButtonWidget.secondary(
        "上一步",
        onTap: Get.back,
      )
      .paddingRight(AppSpace.listRow)
      .flexible(
        flex: 1,
        fit: FlexFit.tight,
      ),


      ButtonWidget.primary(
        text,
        onTap: onTap
      ).flexible(
        flex: 2,
        fit: FlexFit.tight
      ),

    ].toRow(
      mainAxisAlignment: MainAxisAlignment.center
    )
    .paddingHorizontal(
      AppSpace.page
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: _buildView(),
    );
  }
}