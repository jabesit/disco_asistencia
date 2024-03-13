import 'package:disco_asistencia/model/user.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongo {
  static Future<Db> _initDB() async {
    var db = await Db.create(
        "mongodb+srv://juandiaz02:mPs30Or9ilg9rfsv@cluster0.a6xfael.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    await db.open(secure: true);
    return db;
  }

  static Future<bool> insert(User user) async {
    final db = await _initDB();
    final usersCollection = db.collection('users');
    final userExist = await checkUserExist(user);
    if (userExist==null) {
      await usersCollection.insertOne(user.toJson());
      return true;
    } else {
      print("register is not required");
    }
    await db.close();
    return false;
  }

  static changeAdmisibleUser(User user) async {
    final db = await _initDB();
    final usersCollection = db.collection('users');

    final result = await usersCollection.updateOne(
        where.eq('rut', user.rut), modify.set('isAdmisible', user.isAdmisible));
    /* print("result");
    print(result.ok);
    print(result.isSuccess);
    print(result.serverResponses);
    print("result");*/
    if (result.errmsg == null) {
    } else {
      print("error");

      debugPrint(result.errmsg!);
    }
    await db.close();
  }

  static Future<User?> checkUserExist(User user) async {
    final db = await _initDB();
    final usersCollection = db.collection('users');
    final userExist = await usersCollection.findOne({"rut": user.rut});
    print("userExist");
    print(userExist);
    print("userExist");
    await db.close();
    return userExist == null ? null : User.fromJson(userExist);
  }

  static Future<List<User>> getUsers() async {
    List<User> list = [];
    final db = await _initDB();
    final result = await DbCollection(db, 'users').find().toList();
    if (result.isNotEmpty) {
      for (var userJson in result) {
        //print(User.fromJson(userJson).toString());
        list.add(User.fromJson(userJson));
      }
    }
    return list;
  }
}
