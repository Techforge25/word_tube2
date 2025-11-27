import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'dart:developer' as dev;

// ... (your existing LocalClient or any other class)

class DataSharingService {
  // Yeh ek example function hai jo tumhari UI se call hogi
  Future<void> shareGridSizeModel(GridSizeModel modelToShare) async {
    try {
      // 1. Model ko JSON string mein convert karo
      final String jsonString = jsonEncode(modelToShare.toJson());

      // 2. Temporary directory mein file save karo
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/shared_grid_data.wtdata'; // .wtdata custom extension rakho
      final File file = File(filePath);
      await file.writeAsString(jsonString);

      dev.log('File created for sharing at: $filePath');

      // 3. Share sheet open karo
      await Share.shareXFiles([
        XFile(
          filePath,
          mimeType: 'application/wtdata',
        ),
      ], text: 'Check out this game data!');

      dev.log('Share sheet opened for grid data.');

      // Optional: sharing ke baad temporary file delete kar do
      // await file.delete();
    } catch (e) {
      dev.log('Error sharing GridSizeModel: $e', name: 'DataSharingService');
    }
  }

  // Agar multiple models share karne hain
  Future<void> shareMultipleGridSizeModels(
      List<GridSizeModel> modelsToShare) async {
    try {
      // List of models ko JSON list mein convert karo
      final List<Map<String, dynamic>> jsonList =
          modelsToShare.map((model) => model.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);

      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/shared_grid_data_list.wtdata';
      final File file = File(filePath);
      await file.writeAsString(jsonString);

      dev.log('Multiple models file created for sharing at: $filePath');

      await Share.shareXFiles([
        XFile(
          filePath,
          mimeType: 'application/wtdata',
        )
      ], text: 'Check out these game data files!');

      dev.log('Share sheet opened for multiple grid data files.');
    } catch (e) {
      dev.log('Error sharing multiple GridSizeModels: $e',
          name: 'DataSharingService');
    }
  }
}

// Example usage in your UI:
// ElevatedButton(
//   onPressed: () async {
//     // Assuming you have a GridSizeModel object to share
//     GridSizeModel myModel = await LocalClient(isar: isarInstance).getFirstGridSizedModel().then((list) => list.first);
//     await DataSharingService().shareGridSizeModel(myModel);
//   },
//   child: Text('Share Current Game Data'),
// )
