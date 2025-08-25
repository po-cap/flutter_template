import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:template/common/utils/loading.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class VideoCompressFile {
  final XFile video;
  final XFile thumbnail;

  VideoCompressFile({
    required this.video, 
    required this.thumbnail
  });
}


class UCompress {
   
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


  static Future<VideoCompressFile> video(
    AssetEntity asset
  ) async {
    // 1. 先獲取 File 對象
    final file = await asset.file;
    if (file == null) {
      Loading.error("照片檔案獲取失敗");
      throw Exception('File is null');
    }


    /*
     * 獲取壓縮影片
     */
    final media = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.Res640x480Quality,
      deleteOrigin: false, // 默认不要去删除原视频
      includeAudio: true,
      frameRate: 30,
    );

    if(media == null || media.path == null) {
      throw Exception("照片檔案'壓縮失敗");
    }

    final compressFile = media.file;
    if(compressFile == null) {
      throw Exception("照片檔案'壓縮失敗");
    }

    // 獲取文件基本信息 
    int length            = await compressFile.length();
    DateTime lastModified = await compressFile.lastModified();
    String fileName       = compressFile.uri.pathSegments.last;

    // 自動偵測 MIME 類型
    String? mimeType = _detectMimeType(compressFile.path);

    // 如果自動偵測失敗，使用備用方案
    mimeType ??= _getMimeTypeFromExtension(compressFile.path);

    final videoXFile = XFile(
      compressFile.path,
      name: fileName,
      length: length,
      lastModified: lastModified,
      mimeType: mimeType,
    );

    /*
     * 獲取縮圖
     */
    final thumbnail = await VideoCompress.getFileThumbnail(
      file.path,
      quality: 80,
      position: -1000
    );

    final thumbnailXFile = XFile(
      thumbnail.path,
      name: thumbnail.uri.pathSegments.last,
      length: await thumbnail.length(),
      lastModified: await thumbnail.lastModified(),
      mimeType: _detectMimeType(thumbnail.path)
    );  


    return VideoCompressFile(
      video: videoXFile,
      thumbnail: thumbnailXFile
    );
  } 

  // 清理缓存
  static Future<bool?> cleanVideoTmp() async {
    return await VideoCompress.deleteAllCache();
  }

  /// 自動偵測 MIME 類型
  static String? _detectMimeType(String filePath) {
    try {
      // 使用 mime 包偵測 MIME 類型
      final mimeType = lookupMimeType(filePath);
      return mimeType;
    } catch (e) {
      return null;
    }
  }

  /// 根據副檔名推測 MIME 類型
  static String? _getMimeTypeFromExtension(String filePath) {
    // 根據副檔名推測 MIME 類型
    if (filePath.toLowerCase().endsWith('.mp4')) {
      return 'video/mp4';
    } else if (filePath.toLowerCase().endsWith('.mov')) {
      return 'video/quicktime';
    } else if (filePath.toLowerCase().endsWith('.avi')) {
      return 'video/x-msvideo';
    } else if (filePath.toLowerCase().endsWith('.mkv')) {
      return 'video/x-matroska';
    } else if (filePath.toLowerCase().endsWith('.webm')) {
      return 'video/webm';
    } else if (filePath.toLowerCase().endsWith('.3gp')) {
      return 'video/3gpp';
    }
    return 'application/octet-stream'; // 預設類型
  }

}