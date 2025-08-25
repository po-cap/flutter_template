import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:template/common/index.dart';

import 'index.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

 // 5 定义 tag 值，唯一即可
  final String tag = '${Get.arguments['item']?.id ?? ''}';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ItemDetailViewGetX(tag);
  }
}

class _ItemDetailViewGetX extends GetView<ItemDetailController> {
  
  // 1 定义唯一 tag 变量
  final String uniqueTag;

  // 2 接收传入 tag 值
  const _ItemDetailViewGetX(this.uniqueTag);

  // 3 重写 GetView 属性 tag
  @override
  String? get tag => uniqueTag;

  
  Widget _buildOverview() {
    return <Widget>[
        // 商品价格
        TextWidget.h3(
          controller.item.spec['price'],
          color: Get.context!.colors.scheme.error
        ).paddingBottom(AppSpace.listItem),

        TextWidget.body(
          controller.item.description,
          maxLines: null,
        ).paddingBottom(AppSpace.paragraph * 1.5),
    ]
    .toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    )
    .sliverToBoxAdapter();
  }

  // 商品圖片
  _buildGallary() {

    return LayoutBuilder(
      builder:(context, constraints) {
        final width = (constraints.maxWidth - 5) / 2;
        final length = controller.item.album.length;

        span(int length, int index) {
          if(index == 1 || index == 4 || index == 7) {
            if(length - 1 > index) {
              return 1;
            } else {
              return 2;
            }
          }
          else if (index == 2 || index == 5 || index == 8) {
            return 1;
          }
          else {
            return 2;
          }
        }

        return Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [

            for(int i = 0; i < controller.item.album.length; i++)
            ImageWidget.img(
              controller.item.album[i],
              fit: BoxFit.cover,
              width: width * (span(length, i) == 2 ? 2 + 5/width : 1),
              height: width * (span(length, i) == 2 ? 2 + 5/width : 1),
            ).onTap(() {
              Get.to(
                GalleryWidget.network(
                  initialIndex: i, 
                  items: controller.item.album
              ));
            }),
          ],
        );
      }
    ).sliverToBoxAdapter();
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [

        <Widget>[
          ImageWidget.img(
            controller.item.seller.avatar!,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            radius: 20,
          ).paddingRight(AppSpace.listItem),

          TextWidget.h4(
            controller.item.seller.displayName!,
          ),
        ].toRow()
        .onTap(() {
          Get.toNamed(RouteNames.myMyProfile, arguments: {
            'user': controller.item.seller
          });
        })
        .paddingBottom(AppSpace.listItem)
        .sliverToBoxAdapter(),

        // 商品概述
        _buildOverview(),

        // 商品圖片
        _buildGallary(),
      ],
    ).paddingAll(AppSpace.page);
  }


  // 底部按鈕
  Widget _buildButtons() {
    return <Widget>[

      <Widget>[
        <Widget>[
          IconWidget.svg(
            AssetsSvgs.iCommentSvg,
            size: 24,
          ),
          TextWidget.label("留言"),
        ].toColumn().paddingRight(AppSpace.listRow * 2),

        <Widget>[
          IconWidget.svg(
            AssetsSvgs.iBookmarkOutlineSvg,
            size: 24,
          ),
          TextWidget.label("收藏"),
        ].toColumn(),
      ].toRow(),

      <Widget>[
        ButtonWidget.primary(
          "立即購買",
          onTap: () {},
        ).paddingRight(AppSpace.listRow),

        ButtonWidget.primary(
          "聊一聊",
          onTap: controller.onChat,
        ),
      ].toRow(),

    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween
    ).paddingHorizontal(
      AppSpace.page * 2
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailController>(
      init: ItemDetailController(),
      id: "item_detail",
      tag: tag,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: <Widget>[
              SmartRefresher(
                controller: controller.refreshController,
                child: _buildView(),
              ).expanded(),

              _buildButtons(),
            ].toColumn()
          ),
        );
      },
    );
  }
}
