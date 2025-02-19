import 'package:word_toob/src/source/core/client_local.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';

import '../models/grid_model.dart';

abstract class ILocalDataSource {
  final LocalClient localClient;

  const ILocalDataSource({required this.localClient});

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

class LocalDataSource extends ILocalDataSource {
  const LocalDataSource({required super.localClient});

  @override
  Future<List<GridSizeModel>> getAllGridSizedModel() async {
    final response = await localClient.getAllGridSizedModel();
    return response;
  }

  @override
  Future<void> saveAllGridSizedModel(
      {required List<GridSizeModel> gridSizedModelList}) async {
    final response = await localClient.saveAllGridSizedModel(
        gridSizedModelList: gridSizedModelList);
    return response;
  }

  @override
  Future<void> saveGridSizedModel(
      {required GridSizeModel gridSizedModel}) async {
    final response =
        await localClient.saveGridSizedModel(gridSizedModel: gridSizedModel);
    return response;
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
    final response = await localClient.updateGridSizedModel(
      id: id,
      title: title,
      gridSizeX: gridSizeX,
      gridSizeY: gridSizeY,
      listData: listData,
      hideModel: hideModel,
      currentSelected: currentSelected,
      duplicateCount: duplicateCount,
    );
    return response;
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
    final response = await localClient.updateGridSizedModelListDataItem(
        id: id,
        itemIndex: itemIndex,
        title: title,
        hideImage: hideImage,
        videosPath: videosPath,
        hideTitle: hideTitle,
        imagePath: imagePath);
    return response;
  }

  @override
  Future<void> deleteRecord({required int id}) async =>
      await localClient.deleteRecord(id);

  @override
  Future<List<GridSizeModel>> getFirstGridSizedModel() async {
    final response = await localClient.getFirstGridSizedModel();
    return response;
  }
}
