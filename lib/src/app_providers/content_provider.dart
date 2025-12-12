// ignore_for_file: prefer_final_fields
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_toob/src/app_providers/app_setting_provider.dart';
import 'package:word_toob/src/common/app_constants/assets.dart';
import 'package:word_toob/src/common/globals.dart' as globals;
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/source/repository/app_repository.dart';
import 'dart:developer' as dev;

class ContentProvider extends ChangeNotifier {
  final IAppRepository iAppRepository;

  ContentProvider({required this.iAppRepository});

  List<GridSizeModel> _allGridSizedModel = [];
  List<GridSizeModel> get allGridSizedModel => _allGridSizedModel;

  Status getAllGridSizeModelStatus = Status.initial;
  Status updateGridSizeModelStatus = Status.initial;
  Status updateGridListDataStatus = Status.initial;
  Status saveAllGridSizeModelStatus = Status.initial;
  Status saveGridSizeModelStatus = Status.initial;

  List<Uint8List> imagesToBeLoaded = [];
  List<String> namesToBeLoaded = [];

  List<Map<String, dynamic>> _imagePathsPreLoad = [
    {
      "name": "Happy",
      "image": MyAssets.happyP,
    },
    {
      "name": "Sad",
      "image": MyAssets.sad,
    },
    {
      "name": "Mad",
      "image": MyAssets.mad,
    },
    {"name": "Excited", "image": MyAssets.excited},
    {
      "name": "Frustrated",
      "image": MyAssets.frustrated,
    },
    {
      "name": "Scared",
      "image": MyAssets.scared,
    },
    {"name": "Love", "image": MyAssets.love},
    {"name": "Surprised", "image": MyAssets.surprised},
  ];
  List<Map<String, dynamic>> get imagePathsPreLoad => _imagePathsPreLoad;
  Future<void> addVideoToGridItem({
    required int gridSizeModelId,
    required int itemIndex,
    required String videoPath,
  }) async {
    GridSizeModel? parentGrid = allGridSizedModel
        .firstWhereOrNull((element) => element.id == gridSizeModelId);

    if (parentGrid != null &&
        parentGrid.listData != null &&
        itemIndex < parentGrid.listData!.length) {
      GridModel gridItemToUpdate = parentGrid.listData![itemIndex];

      // Global directory path use karo
      String? directoryPath = globals.globalDocumentsDirectoryPath;
      if (directoryPath == null) {
        final directory = await getApplicationDocumentsDirectory();
        directoryPath = directory.path;
        globals.globalDocumentsDirectoryPath = directoryPath;
      }

      // Filename extract karo aur global path ke saath concatenate karo
      final fileName = path.basename(videoPath);
      final newPath = path.join(directoryPath, fileName);
      final newFile = await File(videoPath).copy(newPath);

      gridItemToUpdate.videosPath ??= [];
      // Original videoPath save karo (use time par filename extract hoga)
      gridItemToUpdate.videosPath!.add(videoPath);
      gridItemToUpdate.localVideosPath ??= [];
      // Local path bhi original save karo (use time par filename extract hoga)
      gridItemToUpdate.localVideosPath!.add(newFile.path);

      dev.log(
          "Adding video: $videoPath to GridItem at index $itemIndex on board $gridSizeModelId",
          name: 'ContentProvider');

      await updateGridSizeModelData(
        id: gridSizeModelId,
        listData: parentGrid.listData, // Pass the updated listData
      );

      // updateGridSizeModelData already calls getAllGridSizeModel(),
      // so `allGridSizedModel` will be refreshed automatically.
      // And `notifyListeners()` is also called within updateGridSizeModelData.
    } else {
      dev.log(
          "Error: Parent GridSizeModel (ID: $gridSizeModelId) or GridItem (Index: $itemIndex) not found for adding video.",
          name: 'ContentProvider');
      // Optionally, throw an exception or return a specific error code
    }
  }

  Future getAllGridSizeModel() async {
    getAllGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      _allGridSizedModel = await iAppRepository.getAllGridSizedModel();
      // log(_allGridSizedModel[0].listData.toString());
      notifyListeners();
      getAllGridSizeModelStatus = Status.loaded;
    } on Exception catch (e) {
      getAllGridSizeModelStatus = Status.error;
      dev.log(e.toString());
    }
    notifyListeners();
  }

  Future getFirstGridSizeModel() async {
    getAllGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      _allGridSizedModel = await iAppRepository.getFirstGridSizedModel();

      getAllGridSizeModelStatus = Status.loaded;
    } on Exception catch (e) {
      getAllGridSizeModelStatus = Status.error;
      dev.log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateGridSizeModelData({
    required int id,
    String? title,
    bool? hideModel,
    List<GridModel>? listData,
    int? gridSizeX,
    int? gridSizeY,
    bool? currentSelected,
    int? duplicateCount,
  }) async {
    updateGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      await iAppRepository
          .updateGridSizedModel(
        id: id,
        listData: listData,
        title: title,
        duplicateCount: duplicateCount,
        currentSelected: currentSelected,
        hideModel: hideModel,
        gridSizeY: gridSizeY,
        gridSizeX: gridSizeX,
      )
          .then(
        (value) async {
          await getAllGridSizeModel();
        },
      );
      notifyListeners();
      updateGridSizeModelStatus = Status.loaded;
    } on Exception catch (e) {
      updateGridSizeModelStatus = Status.error;
      dev.log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateListDataItem({
    required int? id, // ID of the GridSizedModel
    required int itemIndex, // Index of the listData item to update
    String? title,
    String? imagePath,
    List<String>? videosPath,
    bool? hideImage,
    bool? hideTitle,
  }) async {
    updateGridListDataStatus = Status.loading;
    notifyListeners();
    try {
      await iAppRepository
          .updateGridSizedModelListDataItem(
        itemIndex: itemIndex,
        id: id,
        title: title,
        imagePath: imagePath,
        hideTitle: hideTitle,
        videosPath: videosPath,
        hideImage: hideImage,
      )
          .then(
        (value) async {
          await getAllGridSizeModel();
          dev.log("getAllGridSizeModel function is called");
        },
      );
      notifyListeners();

      notifyListeners();
      updateGridListDataStatus = Status.loaded;
    } on Exception catch (e) {
      updateGridListDataStatus = Status.error;
      dev.log(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteGrid({required int id}) async {
    updateGridListDataStatus = Status.loading;
    notifyListeners();
    try {
      await iAppRepository.deleteRecord(id: id).then(
        (value) async {
          int i = _allGridSizedModel.indexWhere((a) => a.id! == id);
          _allGridSizedModel.removeAt(i);
        },
      );

      updateGridListDataStatus = Status.loaded;
    } on Exception catch (e) {
      updateGridListDataStatus = Status.error;
      dev.log(e.toString(), name: 'First Grid Error');
    }

    notifyListeners();
  }

  Future saveAllGridSizedModel({
    required List<GridSizeModel> gridSizedModelList,
    required ContentProvider contenProvider,
  }) async {
    saveAllGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      await getAllGridSizeModel();
      if (contenProvider.allGridSizedModel.isEmpty) {
        await iAppRepository.saveAllGridSizedModel(
          gridSizedModelList: gridSizedModelList,
        );
      }

      await getAllGridSizeModel();
      notifyListeners();

      saveAllGridSizeModelStatus = Status.loaded;
    } on Exception catch (e) {
      saveAllGridSizeModelStatus = Status.error;
      dev.log(e.toString());
      // whenExceptionCatch(e);
    }
    notifyListeners();
  }

  Future saveGridSizedModel({required GridSizeModel gridSizedModel}) async {
    saveGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      await getAllGridSizeModel();
      await iAppRepository.saveGridSizedModel(gridSizedModel: gridSizedModel);
      await getAllGridSizeModel();
      // GridSizeModel grid=   allGridSizedModel.firstWhere((grid) => grid.currentSelected==true,orElse:()=> allGridSizedModel[0]);
      // notifyListeners();
      //  mainDashBoard.setGridSizedModel(grid);
      notifyListeners();

      saveGridSizeModelStatus = Status.loaded;
    } on Exception catch (e) {
      saveGridSizeModelStatus = Status.error;
      dev.log(e.toString());
      // whenExceptionCatch(e);
    }
    notifyListeners();
  }
}
