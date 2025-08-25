import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

import 'index.dart';
import 'widgets/index.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  //// 1 定義 tag 值，唯一即可
  //final String tag = Get.arguments['userId'];

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MyProfileViewGetX();
  }
}

class _MyProfileViewGetX extends GetView<MyProfileController> {
  const _MyProfileViewGetX();

  @override
  String? get tag => Get.arguments['user'].id.toString();

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

    // 构建根据滚动状态变化的标题
  Widget _buildAppBarTitle(bool isScrolled) {
    return AnimatedOpacity(
      opacity: isScrolled ? 1.0 : 0.0, // 滚动时显示，展开时隐藏
      duration: Duration(milliseconds: 300),
      child: ImageWidget.img(
        "${controller.user.avatar}",
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        radius: 15,
      ),
    );
  }

  // 滚动图
  Widget _buildProfile(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 280,
      collapsedHeight: 60,

      // 背景色
      backgroundColor: Color.fromRGBO(254, 212, 38, 1),
      iconTheme: IconThemeData(color: Colors.black),

      pinned: true,     // 滚动时固定在顶部
      floating: false,  // 不要快速出现
      snap: false,      // 不要快速展开
      stretch: true,    // 允许下拉拉伸
      
      actions: [
        AnimatedOpacity(
          opacity: controller.isScrolled ? 1.0 : 0.0, // 滚动时显示，展开时隐藏
          duration: Duration(milliseconds: 300),
          child: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("關注"),
          ).marginAll(AppSpace.listRow),
        ),

        GestureDetector(
          onTap: () {
      
          }, 
          child: Icon(Icons.more_horiz_rounded) 
        ).paddingRight(AppSpace.page * 2),
      ],
      title: _buildAppBarTitle(controller.isScrolled),
      
      // 此小组件堆叠在工具栏和选项卡栏后面。其高度将与应用栏的整体高度相同。
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,                 // 背景固定

        //title: _buildAppBarTitle(innerBoxIsScrolled),
        centerTitle: true,


        background: <Widget>[

        // 背景圖
        <Widget>[
          if(controller.user.banner == null)
          IconWidget.svg(
            AssetsSvgs.profileHeaderBackgroundSvg,
            color: Get.context!.colors.scheme.primary,
            fit: BoxFit.cover,
          ),

          if(controller.user.banner != null)
          ImageWidget.img(
            controller.user.banner!,
            fit: BoxFit.fitHeight,
          ).expanded(),

        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),      

        // 內容
        <Widget>[
          <Widget>[
            ImageWidget.img(
              "${controller.user.avatar}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              radius: 50,
            ).paddingRight(AppSpace.listItem),
            TextWidget.h2(
              "${controller.user.displayName}",
            ),
          ]
          .toRow()
          .paddingHorizontal(AppSpace.card)
          .paddingTop(AppSpace.page * 4.5),
          
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly
        ),

      ].toStack(),),
      
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


  // Tab 栏位
  Widget _buildTabBar(BuildContext context) {
    return GetBuilder<MyProfileController>(
      tag: tag,
      id: "profile_tab",
      builder: (_) {
        return <Widget>[
          _buildTabBarItem(context, "商品", 0),
          _buildTabBarItem(context, "評價", 1),
          _buildTabBarItem(context, "文章", 2),
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
          TabItemView(),
          // 评论
          TabReviewView(),
          // 文章
          TabKnowHowView(),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {

    return NestedScrollView(
      controller: controller.scrollController,
      headerSliverBuilder: (_,innerBoxIsScrolled) {
        return [
      
          _buildProfile(innerBoxIsScrolled)
        ];
      }, 
      body: _buildTabView()
    );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(
      init: MyProfileController(),
      id: "my_profile",
      tag: tag,
      builder: (_) {
        return Scaffold(
          body: _buildView(context),
        );
      },
    );
  }
}
