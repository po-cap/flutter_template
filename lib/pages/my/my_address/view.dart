import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';
import 'widgets/index.dart';

class MyAddressPage extends GetView<MyAddressController> {
  const MyAddressPage({super.key});

  // Tab 栏位按钮
  Widget _buildTabBarItem(
    BuildContext context, 
    String textString, 
    int index
  ) {
    return ButtonWidget.outline(
      textString,
      onTap: () => controller.onTapBarTap(index),
      borderRadius: 17,
      borderColor: Colors.transparent,
      textColor: controller.tabIndex == index
          ? context.colors.scheme.onSecondary
          : context.colors.scheme.onPrimaryContainer,
      backgroundColor: controller.tabIndex == index
          ? context.colors.scheme.primary
          : context.colors.scheme.onPrimary,
    ).tight(
      width: 100,
      height: 35,
    );
  }

  // Tab 栏位
  Widget _buildTabBar(BuildContext context) {
    return GetBuilder<MyAddressController>(
      tag: tag,
      id: "profile_tab",
      builder: (_) {
        return <Widget>[
          _buildTabBarItem(context, "宅配", 0),
          _buildTabBarItem(context, "seven店到店", 1),
          _buildTabBarItem(context, "全家店到店", 2),
        ].toRowSpace(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        ).paddingVertical(AppSpace.page);
      },
    );
  }

  // TabView 视图
  Widget _buildTabView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TabBarView(
        controller: controller.tabController,
        children: [
          // 规格
          TabDeliveryView(),
          // 评论
          TabSevenView(),
          // 文章
          TabFamilyView(),
        ],
      ),
    );
  }


  // 主视图
  Widget _buildView(BuildContext context) {
    return <Widget>[
      _buildTabBar(context).paddingTop(AppSpace.page * 2),
      _buildTabView().expanded(),
    ].toColumn()
    .paddingHorizontal(AppSpace.page);
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAddressController>(
      init: MyAddressController(),
      id: "my_address",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 35,
            title: const Text("增加收貨地址"),
            backgroundColor: Colors.transparent,
            actions: [
              ButtonWidget.tertiary(
                "發布",
                onTap: () {},
              ).paddingHorizontal(AppSpace.page * 2)
            ],
          ),
          body: SafeArea(
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
