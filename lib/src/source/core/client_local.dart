import 'package:isar/isar.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/source/models/isar_collection/grid_sized_local.dart';
import '../models/grid_model.dart';
import 'dart:developer' as dev;

class LocalClient {
  final Isar isar;

  LocalClient({
    required this.isar,
  });

  Future<List<GridSizeModel>> getAllGridSizedModel() async {
    final response = await isar.txn(() async {
      List<GridSizedLocal> gridSizedLocalList =
          await isar.gridSizedLocals.where().findAll();
      List<GridSizeModel> gridSizedModalList = [];
      for (var item in gridSizedLocalList) {
        gridSizedModalList.add(GridSizeModel.fromLocal(item));
      }
      return gridSizedModalList;
    });
    dev.log("Fetched local gridSizedModels");
    return response;
  }

  Future<void> saveAllGridSizedModel(
      {required List<GridSizeModel> gridSizedModelList}) async {
    List<GridSizedLocal> gridSizedLocalAll = [];

    for (var item in gridSizedModelList) {
      gridSizedLocalAll.add(GridSizedLocal()
        ..hideModel = item.hideModel
        ..title = item.title
        ..listDataJson = GridSizedLocal().setListData(item.listData ?? [])
        ..gridSizeY = item.gridSizeY
        ..gridSizeX = item.gridSizeX);
    }
    await isar.writeTxn(() async {
      await isar.gridSizedLocals.clear();
      await isar.gridSizedLocals.putAll(gridSizedLocalAll);
      dev.log("Local GridSizedModel all List saved");
    });
  }

  Future<void> saveGridSizedModel(
      {required GridSizeModel gridSizedModel}) async {
    GridSizedLocal gridSizedLocal = GridSizedLocal()
      ..hideModel = gridSizedModel.hideModel
      ..title = gridSizedModel.title
      ..listDataJson =
          GridSizedLocal().setListData(gridSizedModel.listData ?? [])
      ..currentSelected = gridSizedModel.currentSelected
      ..duplicateCount = gridSizedModel.duplicateCount
      ..gridSizeY = gridSizedModel.gridSizeY
      ..gridSizeX = gridSizedModel.gridSizeX;

    await isar.writeTxn(() async {
      List<GridSizedLocal> gridSizedLocalList =
          await isar.gridSizedLocals.where().findAll();
      gridSizedLocalList.add(gridSizedLocal);
      await isar.gridSizedLocals.putAll(gridSizedLocalList);
      dev.log("Local GridSizedModel saved ");
    });
  }

  Future<void> updateGridSizedModel({
    required int id, // Assuming there's an ID to identify the specific model
    String? title,
    bool? hideModel,
    List<GridModel>? listData,
    int? gridSizeX,
    int? gridSizeY,
    bool? currentSelected,
    int? duplicateCount,
  }) async {
    await isar.writeTxn(() async {
      GridSizedLocal? gridSizedLocal = await isar.gridSizedLocals.get(id);

      if (gridSizedLocal != null) {
        gridSizedLocal.title = title ?? gridSizedLocal.title;
        gridSizedLocal.hideModel = hideModel ?? gridSizedLocal.hideModel;
        gridSizedLocal.gridSizeX = gridSizeX ?? gridSizedLocal.gridSizeX;
        gridSizedLocal.gridSizeY = gridSizeY ?? gridSizedLocal.gridSizeY;
        gridSizedLocal.currentSelected =
            currentSelected ?? gridSizedLocal.currentSelected;
        gridSizedLocal.duplicateCount =
            duplicateCount ?? gridSizedLocal.duplicateCount;

        if (listData != null) {
          gridSizedLocal.listDataJson = GridSizedLocal().setListData(listData);
        }

        await isar.gridSizedLocals.put(gridSizedLocal);
        dev.log("Local GridSizedModel updated");
      } else {
        dev.log("GridSizedModel with ID $id not found");
      }
    });
  }

  Future<void> updateGridSizedModelListDataItem({
    required int? id, // ID of the GridSizedModel
    required int itemIndex, // Index of the listData item to update
    String? title,
    String? imagePath,
    List<String>? videosPath,
    bool? hideImage,
    bool? hideTitle,
  }) async {
    await isar.writeTxn(() async {
      // Fetch the GridSizedModel by its ID
      GridSizedLocal? gridSizedLocal = await isar.gridSizedLocals.get(id!);

      if (gridSizedLocal != null) {
        // Fetch the listData and ensure it exists
        List<GridModel>? listData =
            GridSizedLocal().getListData(gridSizedLocal.listDataJson);

        if (itemIndex >= 0 && itemIndex < listData!.length) {
          GridModel gridModelItem = listData[itemIndex];

          gridModelItem.title = title ?? gridModelItem.title;
          gridModelItem.imagepath = imagePath ?? gridModelItem.imagepath;
          gridModelItem.videosPath = videosPath ?? gridModelItem.videosPath;
          gridModelItem.hideImage = hideImage ?? gridModelItem.hideImage;
          gridModelItem.hidetitle = hideTitle ?? gridModelItem.hidetitle;

          listData[itemIndex] = gridModelItem;

          gridSizedLocal.listDataJson = GridSizedLocal().setListData(listData);

          await isar.gridSizedLocals.put(gridSizedLocal);
          dev.log(
              "Local GridSizedModel listData item updated at index $itemIndex");
        } else {
          dev.log("Invalid itemIndex: $itemIndex for listData");
        }
      } else {
        dev.log("GridSizedModel with ID $id not found");
      }
    });
  }
}
