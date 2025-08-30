import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';

class OrderWiget extends StatefulWidget {
  const OrderWiget({
    super.key, 
    required this.item
  });

  final ItemModel item;

  @override
  State<OrderWiget> createState() => _OrderWigetState();
}

class _OrderWigetState extends State<OrderWiget> {

  /// 庫存單元
  List<SkuModel> skus = [];

  /// 被選取的庫存單元
  SkuModel? selectedSku;

  /// 數量
  int quantity = 0;

  /// 最大數量
  int maxQuantity = 0;

  /// 總價錢
  double price = 0;

  /// 收貨地址
  AddressModel? address;


  Future initData() async {
    skus = await ProductApi.getSkus(itemId: widget.item.id);
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    initData();
  }

  Future onPlaceAnOrder() async {

    if(selectedSku == null) {
      Loading.error("請先選擇規格");
      return;
    }

    if(address == null) {
      Loading.error("請先選擇庫存單元");
      return;
    }

    if(quantity == 0) {
      Loading.error("請輸入數量");
      return;  
    }

    Loading.show();
    try {
      await OrderApi.placeAnOrder(
        item: widget.item, 
        sku: selectedSku!, 
        quantity: quantity, 
        recipientName: address!.receiver, 
        recipientPhone: address!.phone, 
        address: address!.toString()
      );

      Get.back();
    
      Loading.success("下單成功");
    }
    finally {
      Loading.dismiss();
    }
  }

  /// 庫存單元
  Widget _buildSkus() {

    final name = skus[0].spec.keys.join('/');

    return [
      TextWidget.body(
        name,
        weight: FontWeight.bold
      ).paddingBottom(AppSpace.listItem * 2),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: skus.map(
          (e) {
            if(selectedSku?.id == e.id) {
              return ButtonWidget.tertiary(
                "${e.name} \$${e.price}",
                onTap: () {
                  setState(() {
                    selectedSku = e;
                    maxQuantity = e.quantity;
                    quantity = 1;
                    price = e.price;
                  });
                },
                borderRadius: 5,
              );
            }

            return ButtonWidget.outline(
              "${e.name} \$${e.price}",
              onTap: () {
                setState(() {
                  selectedSku = e;
                  maxQuantity = e.quantity;
                  quantity = 1;
                  price = e.price;
                });
              },
              borderRadius: 5,
            );
          }
        ).toList()
      ).paddingBottom(AppSpace.listItem * 2),

      <Widget>[
        TextWidget.body(
          "購買數量",
          weight: FontWeight.bold,
          color: Get.context!.colors.scheme.tertiary
        ),
        QuantityWidget(
          quantity: quantity, 
          onChange: (val) {
            if(maxQuantity == 0) {
              setState(() {
                quantity = 0;
                price = 0;
              });
            }
            else {
              if(quantity == maxQuantity && val > maxQuantity) return;
              setState(() {
                quantity = val;
                price = selectedSku!.price * quantity;
              });
            }
          }
        )
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ),

    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start
    ).paddingAll(AppSpace.card);
  }

  /// 商品
  Widget _buildItem({
    required ItemModel item
  }) {
    return [
      ImageWidget.img(
        item.album[0],
        width: 80, 
        height: 80,
        fit: BoxFit.fill,
        radius: 5,
      ).paddingRight(AppSpace.listRow),
      [
        TextWidget.body(
          item.description,
          maxLines: 1,
          weight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
          color: Get.context!.colors.scheme.secondary
        ),
        TextWidget.body(
          item.spec['price'],
          weight: FontWeight.bold,
          color: Get.context!.colors.scheme.error
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start
      )
    ].toRow(
      crossAxisAlignment: CrossAxisAlignment.start
    );
  }

  /// 收貨地址
  Widget _buildAddress() {
    
    final addresses = UserService.to.addresses;

    if(addresses.isNotEmpty) {

      address = addresses[0];

      return ListTile(
        leading: IconWidget.svg(
          AssetsSvgs.locationSvg,
          size: 24,
        ),
        title: TextWidget.body(
          addresses[0].toString(),
          weight: FontWeight.bold,
        ),
        subtitle: TextWidget.label(
          '${addresses[0].receiver} ${addresses[0].phone}',
          color: Get.theme.colorScheme.tertiary,
        ),
        trailing: IconButton(
          onPressed: () {}, 
          icon: Icon(Icons.chevron_right_sharp)
        ),      
      );
    }
    else {
      return ButtonWidget.tertiary(
        "添加收貨地址",
        onTap: () async {
          await Get.toNamed(RouteNames.myMyAddAddress);
          setState(() {});
        }
      ).width(double.infinity)
      .paddingHorizontal(AppSpace.page);
    }
    
  }

  /// 運費
  Widget _buildShippingFee() {

    return <Widget>[

      TextWidget.body(
        "運費",
        weight: FontWeight.bold,
        color: Get.theme.colorScheme.tertiary
      ).paddingRight(AppSpace.listItem),
      TextWidget.body(
        "\$${widget.item.shippingFee}",
        weight: FontWeight.bold,
        color: Get.theme.colorScheme.tertiary
      ),

    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween
    ).border(
      color: Get.theme.colorScheme.surfaceDim,
      bottom: 2
    );
  }

  // 主视图
  Widget _buildView() {
    return CustomScrollView(
      slivers: [
        _buildItem(
          item: widget.item
        ).sliverToBoxAdapter()
        .sliverPaddingVertical(AppSpace.page * 2)
        .sliverPaddingHorizontal(AppSpace.page * 2),

        _buildAddress().sliverToBoxAdapter(),

        if(skus.isNotEmpty)
        _buildSkus().sliverToBoxAdapter()
        .sliverPaddingVertical(AppSpace.page)
        .sliverPaddingHorizontal(AppSpace.page),

        _buildShippingFee().sliverToBoxAdapter()
        .sliverPaddingVertical(AppSpace.listItem)
        .sliverPaddingHorizontal(AppSpace.page * 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(), 
            icon: Icon(Icons.close)
          )
        ],
      ),
      body: _buildView(),
      bottomSheet: ButtonWidget.tertiary(
        price == 0 ? "確定購買" : "確定購買 \$$price",
        scale: WidgetScale.large,
        onTap: onPlaceAnOrder,
      ).width(double.infinity)
      .padding(
        horizontal: AppSpace.page * 2,
        vertical: AppSpace.page
      ),
    );
  }
}