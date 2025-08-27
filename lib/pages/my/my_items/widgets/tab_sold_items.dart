import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/index.dart';

class TabSoldItemsView extends GetView<MyItemsController> {
  const TabSoldItemsView({super.key});


  Widget _buildItem(ItemModel item) {
    return <Widget>[
      <Widget>[
        ImageWidget.img(
          item.album[0],
          width: 60, 
          height: 60,
          fit: BoxFit.fill,
          radius: 5,
        ).paddingRight(AppSpace.appbar),
        <Widget>[
          TextWidget.h4(
            item.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          TextWidget.body(
            item.spec['price'],
            color: Get.theme.colorScheme.onErrorContainer,
          ),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start
        )
      ].toRow(),

      <Widget>[
        IconWidget.svg(
          AssetsSvgs.moreSvg,
          size: 24,
          color: Get.theme.colorScheme.onPrimaryContainer,
        ).paddingHorizontal(AppBorder.card),

        Spacer(),

        ButtonWidget.outline(
          "降價",
          borderRadius: 17,
          borderColor: Colors.transparent,
          textColor: Get.theme.colorScheme.onPrimaryContainer,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          onTap: () {}
        ).paddingRight(AppSpace.listItem),
        ButtonWidget.outline(
          "編輯",
          borderRadius: 17,
          borderColor: Colors.transparent,
          textColor: Get.theme.colorScheme.onPrimaryContainer,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          onTap: () {}
        ),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.end
      ),

    ].toColumn()
    .paddingVertical(AppSpace.card)
    .border(
      bottom: 1,
      color: Get.theme.colorScheme.surfaceDim
    );
  }

    Widget _buildItemsListView() {
    return SliverList(
      delegate : SliverChildBuilderDelegate(
        (context, index) {
          var item = controller.items[index];
          return _buildItem(item);
        },
        childCount: controller.items.length
      )
    );
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
    return GetBuilder<MyItemsController>(
      tag: tag,
      id: "my_sold_items",
      builder: (_) {
        return SmartRefresher(
          controller: controller.refreshController,
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