import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

HiveStorage hiveStorage = HiveStorage();

class HiveStorage {
  HiveStorage._internal();
  static final HiveStorage _instance = HiveStorage._internal();
  factory HiveStorage() {
    return _instance;
  }
  final mybox = Hive.box("WORD_TOOB");

  putData(String key, dynamic value) async {
    await mybox.put(key, value);
  }

  Map<String, dynamic> getAllData() {
    Map<String, dynamic> allData = {};

    List keys = mybox.keys.toList();

    for (var key in keys) {
      var value = mybox.get(key);
      allData[key.toString()] = value;
    }

    return allData;
  }

  getData(String key) {
    var data = mybox.get(key);
    return data;
  }

  putModelData(String key, dynamic value) async {
    await mybox.put(key, jsonEncode(value));
  }

  getModelData(String key) {
    var data = mybox.get(key);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return null;
    }
  }

  /// Save a list of models to Hive
  Future<void> putModelList<T>(
    String key,
    List<T> models,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final jsonList = models.map(toJson).toList();
    await mybox.put(key, jsonList);
  }

  /// Get a list of models from Hive
  Future<List<T>?> getModelList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final rawList = mybox.get(key);

    if (rawList == null || rawList is! List) return null;

    return rawList.map<T>((item) {
      return fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  updateData(String key, dynamic value) async {
    await mybox.put(key, value);
  }

  deleteField(String key) async {
    await mybox.delete(key);
  }

  clearAll() async {
    await mybox.clear();
  }
}

/*Usage of Model List
await hiveStorage.putModelList<CompanyModel>(
  DBKey.allCompanies,
  companies,
  (model) => model.toJson(),
);

final offlineCompanies = await hiveStorage.getModelList<CompanyModel>(
  DBKey.allCompanies,
  (json) => CompanyModel.fromJson(json),
);
*/
