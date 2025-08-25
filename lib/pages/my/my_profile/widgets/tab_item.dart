import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class TabItemView extends GetView<MyProfileController> {
  const TabItemView({super.key});
  
  @override
  String? get tag => Get.arguments['user'].id.toString();


    Widget _buildItemsListView() {
    return SliverWaterfallFlow(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 列数
        crossAxisSpacing: 8, // 列间距
        mainAxisSpacing: 8, // 行间距
      ),
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          var item = controller.items[index];
          return ProductItemWidget(
            item: item,
          );
        },
        childCount: controller.items.length
      ), 
    ).sliverPadding(bottom: AppSpace.page)
    .sliverPaddingHorizontal(AppSpace.page);
  } 


  Widget _buildMainView() {
    return CustomScrollView(
      slivers: [
        _buildItemsListView(),
      ]
    );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(
      tag: tag,
      id: "profile_items",
      builder: (_) {
        return SmartRefresher(
          controller: controller.itemsRefreshController,
          enablePullDown: true,                          // 启用刷新回调
          enablePullUp: true,                            // 启用上拉加载
          onRefresh: controller.onRefreshItems,          // 下拉刷新回调
          onLoading: controller.onLoadingItems,          // 上拉加载回调
          footer: const SmartRefresherFooterWidget(),    // 底部加载更
          child: _buildMainView()
        );
      }
    );
  }
}