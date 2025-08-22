import 'package:get/get.dart';
import 'package:template/common/index.dart';


abstract class MessageRepo { 
  static MessageRepo get to => Get.find();

  /// 取得聊天室訊息
  Future<List<MessageModel>> get({
    required String uri
  }); 

  /// 新增聊天室訊息
  Future<int> insert(MessageModel message);

  /// 更新聊天室訊息
  Future<int> update(MessageModel message);

  /// 刪除聊天室訊息
  Future<int> delete(MessageModel message);

  /// 刪除聊天室訊息
  Future<int> deleteByUri(String uri);
}



class MessageRepoImpl implements MessageRepo{

  /// 取得聊天室訊息
  @override
  Future<int> delete(
    MessageModel message
  ) async {
    
    final db = await LocalDataService.to.database;

    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [ message.id ]
    );
  }

  /// 取得聊天室訊息
  @override
  Future<List<MessageModel>> get({
    required String uri
  }) async {
    
    late List<MessageModel> messages = [];

    await LocalDataService.to.database.then((db) async {
      final maps = await db.query(
        'messages',
        where: 'uri = ?',
        whereArgs: [ uri ],
        orderBy: 'id DESC'
      );

      for (var map in maps) {
        messages.insert(0, MessageModel.fromJson(map));
      }
    });
    
    return messages;
  }

  /// 新增聊天室訊息
  @override
  Future<int> insert(
    MessageModel message
  ) async {
    
    final db = await LocalDataService.to.database;

    final maps = await db.query(
      'messages',
      where: 'id = ?',
      whereArgs: [ message.id ]
    );

    if (maps.isNotEmpty) {
      return 0;
    }

    return await db.insert(
      'messages', 
      message.toJson()
    );
  }

  /// 
  @override
  Future<int> update(
    MessageModel message
  ) async {
    
    final db = await LocalDataService.to.database;

    return await db.update(
      'messages',
      {
        'status': message.status
      }, 
      where: 'id = ?',
      whereArgs: [ message.id ]
    );
  }
  
  @override
  Future<int> deleteByUri(String uri) async {
    final db = await LocalDataService.to.database;

    return await db.delete(
      'messages',
      where: 'uri = ?',
      whereArgs: [ uri ]
    );
  }

}