import 'dart:math';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:template/pages/my/my_index/widgets/bar_item.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});


  // 頂部 APP 導航欄
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      // 背景色
      backgroundColor: Colors.transparent,
      // 固定在頂部
      pinned: true,
      // 浮動在頂部
      floating: true,
       // 自動彈性顯示
      snap: true,
      // 是否应拉伸以填充过度滚动区域。
      stretch: true,
      // 高度
      expandedHeight: 280,
      // 此小组件堆叠在工具栏和选项卡栏后面。其高度将与应用栏的整体高度相同。
      flexibleSpace: FlexibleSpaceBar(
        background: <Widget>[

        <Widget>[
          <Widget>[
            ImageWidget.img(
              "${UserService.to.profile.avatar}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              radius: 50,
            ).paddingRight(AppSpace.listItem),
            TextWidget.h2(
              "${UserService.to.profile.displayName}",
            ),
          ]
          .toRow()
          .paddingHorizontal(AppSpace.card),
          
          <Widget>[
            // 1
            BarItemWidget(
              title: LocaleKeys.myTabWishlist.tr,
              svgPath: AssetsSvgs.iLikeSvg,
            ),
            // 2
            BarItemWidget(
              title: LocaleKeys.myTabFollowing.tr,
              svgPath: AssetsSvgs.iAddFriendSvg,
            ),
            // 3
            BarItemWidget(
              title: LocaleKeys.myTabVoucher.tr,
              svgPath: AssetsSvgs.iCouponSvg,
            ),
          ]                
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
          .paddingSymmetric(
            horizontal: AppSpace.card,
            vertical: AppSpace.card * 2,
          )
          .card(
            color: context.colors.scheme.surface,
          )
          .paddingHorizontal(AppSpace.page), 

        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly
        ),

        ].toStack(),
      )
    );
  }

  // 列表项
  Widget _buildListItem({
    required String txtTitle,
    required String svgPath,
    Function()? onTap,
  }) {
    // 随机颜色
    Color? iconColor;
    iconColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    // 列表项
    return ListTileWidget(
      title: TextWidget.label(txtTitle),
      leading: IconWidget.svg(
        svgPath,
        size: 18,
        color: Colors.white,
      ).paddingAll(6).decorated(
            color: iconColor,
            borderRadius: BorderRadius.circular(30),
          ),
      trailing: const <Widget>[IconWidget.icon(Icons.arrow_forward_ios)],
      onTap: onTap,
    ).height(50);
  }

  // 按钮列表
  Widget _buildButtonsList(BuildContext context) {
    return <Widget>[
      // Edit Profile
      _buildListItem(
        txtTitle: LocaleKeys.myBtnEditProfile.tr,
        svgPath: AssetsSvgs.pCurrencySvg,
        onTap: () {}
      ),

      // Billing Address
      _buildListItem(
        txtTitle: LocaleKeys.myBtnShippingAddress.tr,
        svgPath: AssetsSvgs.pHomeSvg,
        onTap: () {}
      ),

      // Theme
      _buildListItem(
        txtTitle: LocaleKeys.myBtnTheme.tr,
        svgPath: AssetsSvgs.pThemeSvg,
        onTap: () => ConfigService.to.switchThemeMode(),
      ),

      // 调试工具
      _buildListItem(
        txtTitle: LocaleKeys.myBtnStyles.tr,
        svgPath: AssetsSvgs.pCurrencySvg,
        onTap: () => Get.toNamed(RouteNames.stylesStylesIndex),
      ),

    ].toColumn().card().paddingVertical(AppSpace.page);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // 顶部 APP 导航栏
        _buildAppBar(context),
        // 按钮列表
        _buildButtonsList(context).sliverBox,

        // 注销
        ButtonWidget.primary(
          LocaleKeys.myBtnLogout.tr,
          // height: 60,
          onTap: () => controller.onLogout(),
        )
        .padding(
          left: AppSpace.page,
          right: AppSpace.page,
          bottom: AppSpace.listRow * 2,
        )
        .sliverBox,        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: Get.find<MyIndexController>(),
      id: "my_index",
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _buildView(context),
          ),
        );
      },
    );
  }
}
