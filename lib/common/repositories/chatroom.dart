import 'package:get/get.dart';
import 'package:template/common/index.dart';

abstract class ChatroomRepo {
  static ChatroomRepo get to => Get.find();

  /// 取得聊天室
  Future<ChatroomModel?> getByUri({
    required String uri
  });

  /// 取得聊天室
  Future<List<ChatroomModel>> getByUris({
    required List<String> uris
  });

  /// 取得聊天室
  Future<List<ChatroomModel>> get({
    int size = 20,
    int page = 1,
  }); 

  /// 新增聊天室
  Future<int> insert(ChatroomModel chat);

  /// 更新聊天室
  Future update(ChatroomModel chat);


  /// 更新聊天室(從 server 抓到更新數據一次更新)
  Future bucthUpdate(Iterable<ChatroomModel> rooms);

  /// 刪除聊天室
  Future<int> delete(ChatroomModel chat);
}

class ChatroomRepoImpl implements ChatroomRepo {

  /// 刪除聊天室
  @override
  Future<int> delete(
    ChatroomModel chat
  ) async {
    final db = await LocalDataService.to.database;

    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [ chat.uri ],
    );  
  }

  /// 取得聊天室
  @override
  Future<List<ChatroomModel>> getByUris({
    required List<String> uris
  }) async {

    final db = await LocalDataService.to.database;

    final maps = await db.query(
      'chatrooms',
      where: 'uri IN (?)',
      whereArgs: [ uris ],
    );

    return List.generate(maps.length, (i) {
      return ChatroomModel.fromJson(maps[i]);
    });
  }

  /// 取得聊天室
  @override
  Future<ChatroomModel?> getByUri({
    required String uri
  }) async {
    final db = await LocalDataService.to.database;

    final maps = await db.query(
      'chatrooms',
      where: 'uri = ?',
      whereArgs: [ uri ],
    );

    if (maps.isEmpty) {
      return null;
    }

    return ChatroomModel.fromJson(maps.first);
  }

  /// 取得聊天室
  @override
  Future<List<ChatroomModel>> get({
    int size = 20, 
    int page = 1
  }) async {
    final db = await LocalDataService.to.database;
  
    final maps = await db.query(
      'chatrooms',
      orderBy: 'updateAt DESC',
      limit: size,
      offset: (page - 1) * size
    );

    return List.generate(maps.length, (i) {
      return ChatroomModel.fromJson(maps[i]);
    });
  }

  /// 新增聊天室
  @override
  Future<int> insert(
    ChatroomModel chat
  ) async {
    final db = await LocalDataService.to.database;

    return await db.insert(
      'chatrooms', 
      chat.toJson()
    );
  }

  /// 更新聊天室
  @override
  Future update(
    ChatroomModel chat
  ) async {
    final db = await LocalDataService.to.database;


    final maps = await db.query(
      'chatrooms',
      where: 'uri = ?',
      whereArgs: [ chat.uri ],
    );

    if (maps.isEmpty) {
      await db.insert(
        'chatrooms', 
        chat.toJson()
      );
    }
    else {
      await db.update(
        'chatrooms',
        {
          'title': chat.title,
          'avatar': chat.avatar,
          'photo': chat.photo,
          'lastMessageType': chat.lastMessageType?.index,
          'lastMessage': chat.lastMessage,
          'updateAt': chat.updateAt?.millisecondsSinceEpoch
        }, 
        where: 'uri = ?',
        whereArgs: [ chat.uri ],
      );      
    }
  }
  
  @override
  Future bucthUpdate(  
    Iterable<ChatroomModel> rooms
  ) async {
    final db    = await LocalDataService.to.database;
    final batch = db.batch();

    for (final room in rooms) {
      final exist = await db.query(
        'chatrooms',
        where: 'uri = ?',
        whereArgs: [ room.uri ],
      );

      if(exist.isNotEmpty) {
        batch.update(
          'chatrooms', 
          room.toJson(),
          where: 'uri = ?',
          whereArgs: [ room.uri ],
        );
      } 
      else {
        batch.insert(
          'chatrooms', 
          room.toJson()
        );
      }
    }
    await batch.commit();
  }
}