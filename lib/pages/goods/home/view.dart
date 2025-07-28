import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

   // 导航栏
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // 背景透明
      // backgroundColor: Colors.transparent,
      // 取消阴影
      // elevation: 0,
      // 标题栏左侧间距
      titleSpacing: AppSpace.listItem,
      // 搜索栏
      title: <Widget>[
        // 搜索
        IconWidget.icon(
          Icons.search_outlined,
          text: LocaleKeys.gHomeNewProduct.tr,
          size: 24,
          color: context.colors.scheme.outline,
        ).expanded(),

        // 分割线
        SizedBox(
          width: 1,
          height: 18,
          child: Container(
            color: context.colors.scheme.outline,
          ),
        ).paddingHorizontal(5),

        // 拍照
        IconWidget.icon(
          Icons.camera_alt_outlined,
          size: 24,
          color: context.colors.scheme.outline,
        )
      ]
          .toRow()
          .padding(
            left: 20,
            top: 5,
            right: 10,
            bottom: 5,
          )
          .decorated(
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: Border.all(
              color: context.colors.scheme.outline,
              width: 1,
            ),
          )
          .tight(height: 40, width: double.infinity)
          .paddingLeft(10)
          .onTap(controller.onAppBarTap),
      // 右侧的按钮区
      actions: [
        // 图标
        const IconWidget.svg(
          AssetsSvgs.pNotificationsSvg,
          size: 20,
          isDot: true, // 未读消息 小圆点
        )
            .unconstrained() // 去掉约束, appBar 会有个约束下来
            .padding(
              left: AppSpace.listItem,
              right: AppSpace.page,
            ),
      ],
    );
  }

  // 轮播广告
  Widget _buildBanner() {
    return GetBuilder<HomeController>(
            id: "home_banner",
            builder: (_) {
              return CarouselWidget(
                items: controller.bannerItems,
                currentIndex: controller.bannerCurrentIndex,
                onPageChanged: controller.onChangeBanner,
                height: 190,
              );
            })
        .clipRRect(all: AppRadius.image)
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // 分类导航
  Widget _buildCategories() {
    return Container()
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // Flash Sell
  Widget _buildFlashSell() {
    return Container()
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
  }

  // 新商品
  Widget _buildNewItems() {
    return GetBuilder<HomeController>(
      id: "home_new_items",
      builder: (_) {
        return SliverWaterfallFlow(
          gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 列数
            crossAxisSpacing: 8, // 列间距
            mainAxisSpacing: 8, // 行间距
          ),
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              var item = controller.newItems[index];
              return ProductItemWidget(
                item: item,
              );
            },
            childCount: controller.newItems.length
          ), 
        ).sliverPadding(bottom: AppSpace.page)
        .sliverPaddingHorizontal(AppSpace.page);
      },
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        // 轮播广告
        _buildBanner(),

        // 分类导航
        _buildCategories(),

        // Flash Sell
        // title
        Text(LocaleKeys.gHomeFlashSell.tr)
            .sliverToBoxAdapter()
            .sliverPaddingHorizontal(AppSpace.page),

        // list
        _buildFlashSell(),

        // new product
        // title
        Text(LocaleKeys.gHomeNewProduct.tr)
            .sliverToBoxAdapter()
            .sliverPaddingHorizontal(AppSpace.page),

        // list
        _buildNewItems(),
      ],
    );
  }


   @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      id: "home",
      builder: (_) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SmartRefresher(
            controller: controller.refreshController, // 刷新控制器
            enablePullUp: true, // 启用上拉加载
            onRefresh: controller.onRefresh, // 下拉刷新回调
            onLoading: controller.onLoading, // 上拉加载回调
            footer: const SmartRefresherFooterWidget(), // 底部加载更
            child: _buildView()
          ),
        );
      },
    );
  }

}
