import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => Size.fromHeight(35);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: Get.back,
        child: Icon(Icons.arrow_back),
      ),
      actions: [
        GetBuilder<PostItemController>(
          builder: (controller) {
            return ButtonWidget.primary(
              LocaleKeys.postPostButton.tr,
              onTap: controller.onConfirm,
            ).paddingRight(AppSpace.page * 2);
          },
        )
      ],
    );
  }
  
}