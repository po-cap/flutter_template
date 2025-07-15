

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:template/common/utils/loading.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Compress {
   
   static Future<XFile> image(
    AssetEntity asset, {
      int minWidth = 1920,
      int minHeight = 1080
    }
  ) async {
    
    // 1. 先獲取 File 對象
    final file = await asset.file;
    if (file == null) {
      Loading.error("照片檔案獲取失敗");
      throw Exception('File is null');
    }

    final compressFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.absolute.path}_compressed.jpg', // 輸出檔案路徑
      quality: 80, // 壓縮質量 (0-100)
      minWidth: minWidth, // 最小寬度
      minHeight: minHeight, // 最小高度
      rotate: 0, // 旋轉角度
      format: CompressFormat.jpeg, // 輸出格式
    );
    if(compressFile == null) {
      Loading.error("照片檔案'壓縮失敗");
      throw Exception('壓縮失敗');
    }

    return compressFile;
  }

}