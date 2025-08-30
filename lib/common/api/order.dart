import 'package:template/common/index.dart';

class OrderApi {


  static Future<void> placeAnOrder({
    required ItemModel item,
    required SkuModel sku,
    required int quantity,
    double discountAmount = 0,
    required String recipientName,
    required String recipientPhone,
    required String address

  }) async {
    
    await WPHttpService.to.post(
      '/api/order',
      data: {
        'sellerId': item.seller.id,
        'unitPrice': sku.price,
        'quantity': quantity,
        'discountAmount': discountAmount,
        'shippingFee': item.shippingFee,
        'itemId': item.id,
        'skuId': sku.id,
        'item': item.toJson(),
        'sku': sku.toJson(),
        'recipientName': recipientName,
        'recipientPhone': recipientPhone,
        'address': address
      }
    );
  }
}