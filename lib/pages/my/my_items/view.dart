import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/my/my_items/widgets/tab_sold_items.dart';

import 'index.dart';

class MyItemsPage extends GetView<MyItemsController> {
  const MyItemsPage({super.key});

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
    return <Widget>[
      _buildTabBarItem(context, "在賣", 0),
      _buildTabBarItem(context, "已下架", 1),
    ].toRowSpace(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
    ).paddingVertical(AppSpace.page);
  }


  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      collapsedHeight: 60,

      // 背景色
      backgroundColor: Get.theme.colorScheme.surfaceContainer,
      iconTheme: IconThemeData(color: Colors.black),

      pinned: true,     // 滚动时固定在顶部
      floating: false,  // 不要快速出现
      snap: false,      // 不要快速展开
      stretch: true,    // 允许下拉拉伸
      
        
      // 此小组件堆叠在工具栏和选项卡栏后面。其高度将与应用栏的整体高度相同。
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,                 // 背景固定

        //title: _buildAppBarTitle(innerBoxIsScrolled),

      ),
      
      // 底部标签栏
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: Container(
          decoration: BoxDecoration(
            color: Get.context!.colors.scheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
          ),
          child: _buildTabBar(Get.context!)
        )
      ),
    );
  }

  // TabView 视图
  Widget _buildTabView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TabBarView(
        controller: controller.tabController,
        children: [
          // 在賣
          TabSoldItemsView(),
          // 已下架
          Text("佔位")
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return NestedScrollView(
      controller: controller.scrollController,
      headerSliverBuilder: (_,_) {
        return [
      
          _buildAppBar()
        ];
      }, 
      body: _buildTabView()
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyItemsController>(
      init: MyItemsController(),
      id: "my_items",
      builder: (_) {
        return Scaffold(
          body: _buildView(context),
        );
      },
    );
  }
}
