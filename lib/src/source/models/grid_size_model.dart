import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/isar_collection/grid_sized_local.dart';

import 'dart:developer' as dev;

/// Model representing a grid with size dimensions, title, and list of grid items
class GridSizeModel {
  int? id;
  late int duplicateCount;
  int? gridSizeX;
  int? gridSizeY;
  String? title;
  bool? hideModel;
  List<GridModel>? listData;
  late bool currentSelected;

  GridSizeModel({
    this.id,
    this.gridSizeX,
    this.hideModel,
    this.gridSizeY,
    this.listData,
    this.title,
    this.duplicateCount = 1,
    this.currentSelected = false,
  });

  /// Hide the grid model
  void setHide() {
    hideModel = true;
  }

  /// Show the grid model
  void showHide() {
    hideModel = false;
  }

  /// Create a GridSizeModel from local storage data
  GridSizeModel.fromLocal(GridSizedLocal localDetails) {
    try {
      gridSizeX = localDetails.gridSizeX;
      gridSizeY = localDetails.gridSizeY;
      listData = localDetails.getListData(localDetails.listDataJson);
      title = localDetails.title;
      hideModel = localDetails.hideModel;
      currentSelected = localDetails.currentSelected;
      duplicateCount = localDetails.duplicateCount;
      id = localDetails.id;
    } catch (e) {
      dev.log("GridSizeModel.fromLocal: $e");
    }
  }
  factory GridSizeModel.fromJson(Map<String, dynamic> json) {
    try {
      return GridSizeModel(
        id: json['id'],
        gridSizeX: json['gridSizeX'],
        gridSizeY: json['gridSizeY'],
        title: json['title'],
        hideModel: json['hideModel'],
        listData: (json['listData'] as List<dynamic>?)
            ?.map((item) => GridModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        duplicateCount: json['duplicateCount'] ?? 1,
        currentSelected: json['currentSelected'] ?? false,
      );
    } catch (e) {
      dev.log("GridSizeModel.fromJson: $e");
      return GridSizeModel(); // fallback empty model
    }
  }

  /// Convert GridSizeModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gridSizeX': gridSizeX,
      'gridSizeY': gridSizeY,
      'title': title,
      'hideModel': hideModel,
      'listData': listData?.map((item) => item.toJson()).toList(),
      'duplicateCount': duplicateCount,
      'currentSelected': currentSelected,
    };
  }
}
