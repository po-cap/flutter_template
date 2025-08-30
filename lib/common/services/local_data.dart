

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataService extends GetxService {
  static LocalDataService get to => Get.find(); 

  /// 資料庫
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/chat.db';

    return await openDatabase(
      path, 
      version: 1,
      onCreate: _createDB
    );
  }

  // 建立資料庫
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chatrooms (
        uri             TEXT NOT NULL PRIMARY KEY,
        partnerId       INTEGER NOT NULL,
        title           TEXT NOT NULL,
        avatar          TEXT NOT NULL,
        photo           TEXT,
        lastMessageType INTEGER,
        lastMessage     TEXT,
        updateAt        INTEGER
      )
    ''');
    
    // 可以创建更多表
    await db.execute('''
      CREATE TABLE messages (
        id         INTEGER PRIMARY KEY,
        uri        TEXT NOT NULL,
        receiverId INTEGER NOT NULL,
        content    TEXT NOT NULL,
        type       INTEGER NOT NULL,
        status     INTEGER NOT NULL,
        tag        TEXT
      )
    ''');    

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_messages_uri
      ON messages(`uri`);
    ''');
  }

  Future<void> delete() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/chat.db';
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
      debugPrint('文件已删除');
    } else {
      debugPrint('文件不存在');
    }
  }
}