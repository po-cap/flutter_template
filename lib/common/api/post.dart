

import 'package:dio/dio.dart';
import 'package:template/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostApi {

  /// 上傳照片（影片）
  static Future<String> upload(AssetEntity asset) async {

    // 1. 壓縮照片
    final file = await Compress.image(asset);
  
    // 2. 獲取照片檔案名稱
    final name = file.name;

   // 2. 讀取文件數據並轉換為 MultipartFile
    final fileBytes = await file.readAsBytes();
    final multipartFile = MultipartFile.fromBytes(
      fileBytes,
      filename: name,
    );   

    // 3. 構建 FormData
    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    // 4. 發送 POST 請求
    final res = await WPHttpService.to.post(
      '/api/image',
      data: formData,
    );

    // 5. 解析返回數據
    final data = PostImageRes.fromJson(res.data);
  
    // 6. 返回照片網址
    return data.url;
  }

  /// 新增鏈結
  static Future<void> addItem({
    required String description,
    required List<String> album,
    required List<SkuModel> skus
  }) async { 
    await WPHttpService.to.post(
      '/api/item',
      data: {
        'description': description,
        'album': album,
        'skus': skus.map((e) => {
          'name': e.name,
          'specs': e.specs,
          'photo': e.photo,
          'price': e.price,
          'quantity': e.quantity
        }).toList()
      }
    );
  }
}