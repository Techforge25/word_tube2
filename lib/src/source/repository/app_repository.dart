import 'package:word_toob/src/common/app_constants/general.dart';
import 'package:word_toob/src/source/data_source/local_data_source.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';

abstract class IAppRepository {
  final ILocalDataSource localDataSource;
  const IAppRepository({required this.localDataSource});

  Future<List<GridSizeModel>> getAllGridSizedModel();

  Future<List<GridSizeModel>> getFirstGridSizedModel();
  Future<void> saveAllGridSizedModel({
    required List<GridSizeModel> gridSizedModelList,
  });
  Future<void> saveGridSizedModel({required GridSizeModel gridSizedModel});
  Future<void> updateGridSizedModel({
    required int id, // Assuming there's an ID to identify the specific model
    String? title,
    bool? hideModel,
    List<GridModel>? listData,
    int? gridSizeX,
    int? gridSizeY,
    bool? currentSelected,
    int? duplicateCount,
  });
  Future<void> updateGridSizedModelListDataItem({
    required int? id, // ID of the GridSizedModel
    required int itemIndex, // Index of the listData item to update
    String? title,
    String? imagePath,
    List<String>? videosPath,
    bool? hideImage,
    bool? hideTitle,
  });

  Future<void> deleteRecord({required int id});
}

class AppRepository extends IAppRepository {
  AppRepository({required super.localDataSource});

  @override
  Future<List<GridSizeModel>> getAllGridSizedModel() async {
    try {
      final response = await localDataSource.getAllGridSizedModel();
      return response;
    } catch (e) {
      printLog(e.toString());
      return [];
    }
  }

  @override
  Future<void> saveAllGridSizedModel(
      {required List<GridSizeModel> gridSizedModelList}) async {
    try {
      await localDataSource.saveAllGridSizedModel(
          gridSizedModelList: gridSizedModelList);
    } catch (e) {
      printLog(e.toString());
    }
  }

  @override
  Future<void> saveGridSizedModel(
      {required GridSizeModel gridSizedModel}) async {
    try {
      await localDataSource.saveGridSizedModel(gridSizedModel: gridSizedModel);
    } catch (e) {
      printLog(e.toString());
    }
  }

  @override
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
    try {
      await localDataSource.updateGridSizedModel(
          id: id,
          title: title,
          gridSizeX: gridSizeX,
          gridSizeY: gridSizeY,
          listData: listData,
          hideModel: hideModel,
          currentSelected: currentSelected,
          duplicateCount: duplicateCount);
    } catch (e) {
      printLog(e.toString());
    }
  }

  @override
  Future<void> updateGridSizedModelListDataItem({
    required int? id, // ID of the GridSizedModel
    required int itemIndex, // Index of the listData item to update
    String? title,
    String? imagePath,
    List<String>? videosPath,
    bool? hideImage,
    bool? hideTitle,
  }) async {
    final response = await localDataSource
        .updateGridSizedModelListDataItem(
      id: id,
      itemIndex: itemIndex,
      title: title,
      hideImage: hideImage,
      videosPath: videosPath,
      hideTitle: hideTitle,
      imagePath: imagePath,
    )
        .then(
      (value) async {
        await getAllGridSizedModel();
      },
    );
    return response;
  }

  @override
  Future<void> deleteRecord({required int id}) async {
    final response = await localDataSource.deleteRecord(id: id).then(
          (value) async {},
        );
    return response;
  }

  @override
  Future<List<GridSizeModel>> getFirstGridSizedModel() async {
    try {
      final response = await localDataSource.getFirstGridSizedModel();
      return response;
    } catch (e) {
      printLog(e.toString());
      return [];
    }
  }
}
