import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

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

  // New Sell
  Widget _buildNewSell() {
    return Container()
        .sliverToBoxAdapter()
        .sliverPaddingHorizontal(AppSpace.page);
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
        _buildNewSell(),
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
          body: _buildView(),
        );
      },
    );
  }

}
