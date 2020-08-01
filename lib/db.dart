//import 'package:idb_shim/idb_browser.dart';
//import 'package:idb_shim/idb_shim.dart';
import 'dart:io';

import 'package:idb_sqflite/idb_sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

  //IdbFactory idbFactory = getIdbFactory();
  IdbFactory idbFactory = Platform.isLinux? getIdbFactorySqflite(databaseFactoryFfi): getIdbFactorySqflite(sqflite.databaseFactory);
Future<bool> putData(Map value, String id,
    {String keyword = 'savedNews'}) async {
  bool success = false;
  Database db = await idbFactory.open('news', version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
    print(event.newVersion);
    Database db = event.database;
    db.createObjectStore(keyword);
    print(db.name);
  });
  var txn = db.transaction(keyword, "readwrite");
  var store = txn.objectStore(keyword);
  try {
    await store.add(value, id);
    await txn.completed;
    success = true;
    print('done');
  } catch (e) {
    print('ERROR 23:' + e.toString());
  }
  return success;
}

Future<List<Map>> getData({String keyword = 'savedNews'}) async {
  List<Map> data = [];
  Database db = await idbFactory.open('news', version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
    print(event.newVersion);
    Database db = event.database;
    db.createObjectStore(keyword);
    print(db.name);
  });
  var txn = db.transaction(keyword, idbModeReadOnly);
  var store = txn.objectStore(keyword);
  try {
    store
        .openCursor(direction: idbDirectionPrev, autoAdvance: true)
        .listen((cursor) {
      data.add(cursor.value);
    });
    await txn.completed;
    print('done');
  } catch (e) {
    print('ERROR 48:' + e.toString());
  }
  return data;
}

Future deleteData(String id, {String keyword = 'savedNews'}) async {
  Database db = await idbFactory.open('news', version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
    print(event.newVersion);
    Database db = event.database;
    db.createObjectStore(keyword);
    print(db.name);
  });
  var txn = db.transaction(keyword, idbModeReadWrite);
  var store = txn.objectStore(keyword);
  try {
    await store.delete(id);
    await txn.completed;
    print('done');
  } catch (e) {
    print('ERROR 48:' + e.toString());
  }
}
