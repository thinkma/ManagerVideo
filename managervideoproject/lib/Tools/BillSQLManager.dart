import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'SQLMethod.dart';
import 'ConstantUtils.dart';


 class BillSQLManager extends SQLMethod {
  // static BillSQLManager _instance  = BillSQLManager.getInstance();
  // late Database _db;

  // static BillSQLManager getInstance() {
  //   if (_instance == null) {
  //     _instance = BillSQLManager();
  //   }
  //   return _instance;
  // }

  factory BillSQLManager() =>_sharedInstance();
  
  // 静态私有成员，没有初始化
  static BillSQLManager _instance = BillSQLManager._();
  
  // 私有构造函数
  BillSQLManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static BillSQLManager _sharedInstance() {
    return _instance;
  }

 late Database _db;
  Future<Database> initDB() async {
  final databasePath = await getDatabasesPath();
  print('SQLManager.initDB -> databasePath = $databasePath');
  final path = join(databasePath, ConstantUtils.DB_NAME);
  _db = await openDatabase(path,
      version: ConstantUtils.DB_VERSION,
      onCreate: (_db, _) => _db.execute(ConstantUtils.CREATE_BILL_SQL));
  return _db;
}

  @override
  closeDB() {
    // TODO: implement closeDB
    throw UnimplementedError();
  }

  @override
  Future<int> deleteAll(String tableName) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<int> deleteByParams(String tableName, String key, Object value) async{
    // TODO: implement deleteByParams
    // throw UnimplementedError();
  if (key != null) {
    return await _db.delete(tableName, where: '$key=?', whereArgs: [value]);
  } else {
    return -1;
  }
    
  }

  @override
  Future<int> insertByJson(String tableName, String json) {
    // TODO: implement insertByJson
    throw UnimplementedError();
  }

  @override
  Future<int> insertByMap(String tableName, Map<String, dynamic> map) async {
  int result = 0;
  if (map != null) {
    result = await _db.insert(tableName, map);
  }
  return result;
 
  }

  @override
  Future<int> insertSQL(String sql) {
    // TODO: implement insertSQL
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> queryList(String tableName, {int count = 1000, String keys = "updateTime",String orderBy = "DESC"}) async{
    List<Map<String, dynamic>> list = await _db.query(tableName, orderBy: '${keys} ${orderBy ?? 'DESC'}');
  if (list != null) {
    if (count != null && count > 0) {
      if (count >= list.length) {
        return list;
      } else {
        return list.sublist(0, count);
      }
    } else {
      return list;
    }
  }
  return list;

  }

/*
let sqlString = "SELECT * FROM VIDEOSOURCE_LIST WHERE VideoSourceName LIKE '%\(searchText)%' ORDER BY VideoSourceName DESC"
*/
  Future<List<Map<String, dynamic>>> querySearchList(String tableName,String search, {int count = 1000, String keys = "VideoName",String orderBy = "DESC"}) async{
    search = "%${search}%";
    List<Map<String, dynamic>> list = await _db.query(tableName, where: '$keys LIKE ?', whereArgs: [search],orderBy: '${keys} ${orderBy ?? 'DESC'}');
  if (list != null) {
    if (count != null && count > 0) {
      if (count >= list.length) {
        return list;
      } else {
        return list.sublist(0, count);
      }
    } else {
      return list;
    }
  }
  return list;

  }


  // @override
  // Future<List<Map<String, dynamic>>> queryListByPage(String tableName, int limitCount, int pageSize, {String orderBy}) {
  //   // TODO: implement queryListByPage
  //   throw UnimplementedError();
  // }

  @override
  updateByMap(String tableName, Map<String, dynamic> map) {
    // TODO: implement updateByMap
    throw UnimplementedError();
  }
  @override
  updateByParams(String tableName, String key, Object value, Map<String, dynamic> map) async{
      if (key != null) {
          return await _db.update(tableName, map, where: '$key=?', whereArgs: [value]);
        }
          return null;
  }


  @override
  updateSQL(String tableName, String sql) {
    // // TODO: implement updateSQL
    // throw UnimplementedError();
  }
}