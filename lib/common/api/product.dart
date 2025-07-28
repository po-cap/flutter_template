import 'package:template/common/index.dart';

class ProductApi {

  static Future<List<ItemModel>> getByUserId({
    required int userId,
    required int limit,
    int? lastId
  }) async {
    
    // 設定參數
    Map<String, dynamic> params = {
      'userId': userId,
      'size': limit
    };
    if(lastId != null) {
      params['lastId'] = lastId;
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