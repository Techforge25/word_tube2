// ignore_for_file: prefer_final_fields
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:word_toob/src/app_providers/app_setting_provider.dart';
import 'package:word_toob/src/common/app_constants/assets.dart';
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
              gridSizeX: gridSizeX)
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

  Future saveAllGridSizedModel(
      {required List<GridSizeModel> gridSizedModelList,
      required ContentProvider contenProvider}) async {
    saveAllGridSizeModelStatus = Status.loading;
    notifyListeners();
    try {
      await getAllGridSizeModel();
      if (contenProvider.allGridSizedModel.isEmpty) {
        await iAppRepository.saveAllGridSizedModel(
            gridSizedModelList: gridSizedModelList);
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
