import 'package:template/common/index.dart';

class ProductApi {

  /// 根據ID獲取商品
  static Future<ItemModel> getById({
    required int id
  }) async {
    final res = await WPHttpService.to.get(
      '/api/item',
      params: {
        'id': id
      }
    );

    return ItemModel.fromJson(res.data);
  }

  /// 獲取最新商品
  static Future<List<ItemModel>> getNewest({
    required int limit,
    int? lastId,
    int? userId,
  }) async {
    
    // 設定參數
    Map<String, dynamic> params = {
      'size': limit
    };
    if(lastId != null) {
      params['lastId'] = lastId;
    }
    if(userId != null) {
      params['userId'] = userId;
    }
    
    // 發送請求(拉取數據)
    final res = await WPHttpService.to.get(
      '/api/item',
      params: params
    );

    // 解析(整理)數據
    List<ItemModel> items = [];
    for(var item in res.data) {
      items.add(ItemModel.fromJson(item));
    }

    return items;
  }

}