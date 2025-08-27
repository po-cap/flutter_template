
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.onConfirm
  });

  final void Function()? onConfirm;

  @override
  Size get preferredSize => Size.fromHeight(35);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Get.theme.colorScheme.surface,
      elevation: 0,
      leading: InkWell(
        onTap: Get.back,
        child: Icon(Icons.arrow_back),
      ),
      actions: [
        ButtonWidget.tertiary(
          "發布",
          onTap: onConfirm,
        ).paddingHorizontal(AppSpace.page * 2)
        
        //GetBuilder<PostItemController>(
        //  builder: (controller) {
        //    return ButtonWidget.tertiary(
        //      LocaleKeys.postPostButton.tr,
        //      onTap: controller.onConfirm,
        //    ).paddingRight(AppSpace.page * 2);
        //  },
        //)
      ],
    );
  }
  
}