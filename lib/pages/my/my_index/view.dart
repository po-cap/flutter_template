import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});

    // 构建根据滚动状态变化的标题
  Widget _buildAppBarTitle() {
    return AnimatedOpacity(
      opacity: controller.isScrolled ? 1.0 : 0.0, // 滚动时显示，展开时隐藏
      duration: Duration(milliseconds: 300),
      child: <Widget>[
        ImageWidget.img(
          "${UserService.to.profile.avatar}",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          radius: 15,
        ),
        TextWidget.body("${UserService.to.profile.displayName}"),
        IconWidget.svg(
          AssetsSvgs.settingSvg,
          size: 30,
        )

      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ),
    );
  }

  // 頂部 APP 導航欄
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 60,
      expandedHeight: 150,
      backgroundColor: Get.theme.colorScheme.surface,
      pinned: true,
      floating: true,
      snap: false,
      stretch: true,
      
      title: _buildAppBarTitle(),

      // 此小组件堆叠在工具栏和选项卡栏后面。其高度将与应用栏的整体高度相同。
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: <Widget>[
          ImageWidget.img(
            "${UserService.to.profile.avatar}",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            radius: 50,
          ).paddingRight(AppSpace.listItem).onTap(() {
            Get.toNamed(
              RouteNames.myMyProfile,
              arguments: {
                'user': UserService.to.profile
            });
          }),
          TextWidget.h3(
            "${UserService.to.profile.displayName}",
          ).onTap(() {
            Get.toNamed(
              RouteNames.myMyProfile,
              arguments: {
                'user': UserService.to.profile
            });
          }),
          Spacer(),
          _buildSvgButton(
            icon: AssetsSvgs.settingSvg, 
            label: "設置"
          ).paddingHorizontal(AppSpace.page),
        ]
        .toRow()
        .paddingHorizontal(AppSpace.card)
        .paddingTop(AppSpace.page * 4.5),
    ));
  }

  Widget _buildCountButton({
    required String label,
    int count = 0
  }) {
    return <Widget>[
      TextWidget.h4(
        count.toString(),
      ),
      TextWidget.label(
        label,
      ),
    ].toColumn();
  }


  Widget _buildSvgButton({
    required String icon,
    required String label,
    int count = 0,
    Function()? onTap
  }) {
    return <Widget>[
      IconWidget.svg(
        icon,
        size: 36,
        badgeString: count > 0 ? count.toString() : null,        
      ),
      TextWidget.label(
        label,
      ),
    ].toColumn(
      mainAxisSize: MainAxisSize.min
    ).onTap(onTap);
  }

  Widget _buildListInteraction() {
    return <Widget>[
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          _buildCountButton(
            count: 3, 
            label: "我的收藏"
          ),
          _buildCountButton(
            count: 198, 
            label: "歷史瀏覽"
          ),
          _buildCountButton(
            count: 33, 
            label: "我的關注"
          ),
          _buildCountButton(
            count: 0, 
            label: "紅包卡卷"
          ),                             
        ]
      ).width(double.infinity),


    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    )
    .paddingAll(AppSpace.page * 1.2)
    .card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(AppSpace.page),
      color: Get.theme.colorScheme.surfaceContainer,
      elevation: 2.0
    );
  }

  Widget _buildListTransaction() {
    return <Widget>[
      TextWidget.h4("交易記錄")
      .paddingBottom(AppSpace.listItem),

      Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          _buildSvgButton(
            icon: AssetsSvgs.bagSvg, 
            label: "我的發布",
            onTap: () {
              Get.toNamed(RouteNames.myMyItems);
            },
          ),
          _buildSvgButton(
            icon: AssetsSvgs.moneyBagSvg, 
            label: "我賣出的"
          ),
          _buildSvgButton(
            icon: AssetsSvgs.checklistSvg, 
            label: "我買到的"
          ),
          _buildSvgButton(
            icon: AssetsSvgs.reviewSvg, 
            label: "待評價"
          ),                              
        ]
      ).width(double.infinity),


    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    )
    .paddingAll(AppSpace.page * 1.2)
    .card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(AppSpace.page),
      color: Get.theme.colorScheme.surfaceContainer,
      elevation: 2.0
    );
  }


  // 列表项
  Widget _buildListItem({
    required String txtTitle,
    required String svgPath,
    Function()? onTap,
  }) {
    // 列表项
    return ListTileWidget(
      title: TextWidget.body(txtTitle),

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
        onTap: controller.onEditAddress
      ),

    ].toColumn().card()
    .paddingHorizontal(AppSpace.page)
    .paddingVertical(AppSpace.page);
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return NestedScrollView(
      controller: controller.scrollController,
      headerSliverBuilder: (_,innerBoxIsScrolled) {
        return [
          // 顶部 APP 导航栏
          _buildAppBar(context),
        ];
      },
      body: <Widget>[
        _buildListInteraction(),

        _buildListTransaction(),

        // 按钮列表
        _buildButtonsList(context),

        // 注销
        ButtonWidget.primary(
          LocaleKeys.myBtnLogout.tr,
          onTap: () => controller.onLogout(),
        )
        .width(double.infinity)
        .padding(
          left: AppSpace.page,
          right: AppSpace.page,
          bottom: AppSpace.listRow * 2,
        ),        
      ].toColumn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: Get.find<MyIndexController>(),
      id: "my_index",
      builder: (_) {
        return Scaffold(
          backgroundColor: Get.theme.colorScheme.surface,
          body: _buildView(context),
        );
      },
    );
  }
}
