// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/common/utils/constant.dart';
import 'package:word_toob/src/common/utils/hive_storage_helper.dart';
import 'package:word_toob/src/dependency_inject.dart';
import 'package:word_toob/src/func/device_check.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/services/firebase_storage_service.dart';
import 'package:word_toob/src/views/widgets/edit_pop_over.dart';
import '../common/app_constants/route_strings.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'dart:developer' as dev;
import 'package:path/path.dart' as p;

class MainDashboardController extends ChangeNotifier {
  TextEditingController editTitleTextEditingController =
      TextEditingController();

  TextEditingController boradTitleController = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();
  int _gridSizeX = 1;

  int get gridSizeX => _gridSizeX;

  int _gridSizeY = 2;
  int get gridSizeY => _gridSizeY;

  bool _editPressedYello = false;
  bool get editPressedYello => _editPressedYello;

  int? _itemClickedOnEditState;
  int? get itemClickedOnEditState => _itemClickedOnEditState;

  bool _itemClickeBool = false;
  bool get itemClickeBool => _itemClickeBool;

  bool _showBottomSheet = false;
  bool get showBottomSheet => _showBottomSheet;

  bool _showBottomSheetVideo = false;
  bool get showBottomSheetVideo => _showBottomSheetVideo;

  bool _isEditPressed = false;
  bool get isEditPressed => _isEditPressed;

  int _settingsWordOnlyShow = 1;
  int get settingsWordOnlyShow => _settingsWordOnlyShow;

  int _gridIndex = 0;
  int get gridIndex => _gridIndex;

  bool _useSpeech = true;
  bool get useSpeech => _useSpeech;

  bool _findWordImage = false;
  bool get findWordImage => _findWordImage;

  bool _lottie = false;
  bool get lottie => _lottie;

  bool _findTheWord = false;
  bool get findTheWord => _findTheWord;

  bool _freePlay = false;
  bool get freePlay => _freePlay;

  bool _foundSuccess = false;
  bool get foundSuccess => _foundSuccess;

  String _targetFindWord = "";
  String get targetFindWord => _targetFindWord;

  String _findWordImagePath = "";
  String get findWordImagePath => _findWordImagePath;

  bool _isTapped = false;
  bool get isTapped => _isTapped;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRepeateTap = false;
  bool get isRepeateTap => _isRepeateTap;

  bool _isUploadCancelled = false;
  bool get isUploadCancelled => _isUploadCancelled;
  Completer<void>? _uploadCancelCompleter;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void cancelUpload() {
    _isUploadCancelled = true;
    _uploadCancelCompleter?.complete();
    notifyListeners();
  }

  void resetUploadCancellation() {
    _isUploadCancelled = false;
    _uploadCancelCompleter = null;
    notifyListeners();
  }

  void setIsTapped(bool value) {
    _isTapped = value;
    notifyListeners();
  }

  void setIsRepeate(bool value) {
    _isRepeateTap = value;
    notifyListeners();
  }

  int _randomListIndex = 0;
  int get randomListIndex => _randomListIndex;

  void setRandomListIndex(int i) => _randomListIndex = i;

  List<String> _videos = [];
  List<String> get videos => _videos;

  List<String> dismissedVideos = [];
  List<String> get visibleVideos =>
      _videos.where((video) => !dismissedVideos.contains(video)).toList();

  List<GridModel> _gridItemMain = [];
  List<GridModel> get gridItemMain => _gridItemMain;

  GridSizeModel _gridSizedModel = GridSizeModel();
  GridSizeModel get gridSizedModel => _gridSizedModel;

  GridSizeModel _duplicateGridSizedModel = GridSizeModel();
  GridSizeModel get duplicateGridSizedModel => _duplicateGridSizedModel;

  List<int> _findTheWordWrongList = [];
  List<int> get findTheWordWrongList => _findTheWordWrongList;

  bool _speechToTextCheck = false;
  bool get speechToTextCheck => _speechToTextCheck;

  void setSpeechToText(BuildContext context) {
    _speechToTextCheck = !_speechToTextCheck;
    if (_speechToTextCheck) {
      startListening(context);
    } else {
      stopListening();
    }
    notifyListeners();
  }

  ///Speech to text
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  Future<void> initSpeechToText() async {
    try {
      // Stop any existing listening session before initializing
      if (speechToText.isListening) {
        await speechToText.stop();
      }

      speechEnabled = await speechToText.initialize(
        onStatus: onStatus,
        onError: onError,
      );

      if (!speechEnabled) {
        dev.log('Speech recognition not available', name: 'Microphone');
      }

      notifyListeners();
    } catch (e) {
      dev.log('Error initializing speech recognition: $e', name: 'Microphone');
      speechEnabled = false;
      _speechToTextCheck = false;
      notifyListeners();
    }
  }

  void onStatus(String s) {
    dev.log(s, name: 'Listening Status');
    if (!speechToText.isListening) {
      _speechToTextCheck = false;
      notifyListeners();
    }
  }

  void onError(SpeechRecognitionError e) {
    dev.log(e.errorMsg, name: 'Listening Error');
    _speechToTextCheck = false;
    notifyListeners();
  }

  double _soundLevel = 0.0;
  double get soundLevel => _soundLevel;

  void startListening(BuildContext context) async {
    try {
      if (!speechEnabled) {
        await initSpeechToText();
        // If still not enabled after initialization, return
        if (!speechEnabled) {
          dev.log('Speech recognition not available, cannot start listening',
              name: 'Microphone');
          _speechToTextCheck = false;
          notifyListeners();
          return;
        }
      }

      // Ensure any existing session is stopped
      if (speechToText.isListening) {
        await speechToText.stop();
        // Wait a bit for cleanup
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            dev.log('Final result: ${result.recognizedWords}',
                name: 'Microphone');
          } else {
            dev.log('Partial: ${result.recognizedWords}', name: 'Microphone');
          }

          if (_speechToTextCheck && result.recognizedWords.isNotEmpty) {
            onSpeechResult(result, context);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: false, // Don't cancel on error, handle it gracefully
        localeId: "en_US", // Specify locale for better recognition
        onSoundLevelChange: (level) {
          _soundLevel = level;
          notifyListeners();
        },
      );

      _speechToTextCheck = true;
      notifyListeners();
    } catch (e) {
      dev.log('Error starting speech recognition: $e',
          name: 'Microphone Error');
      _speechToTextCheck = false;
      speechEnabled = false;
      notifyListeners();
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  ///

  void stopListening() async {
    if (speechToText.isListening) {
      await speechToText.stop();
    }
    _speechToTextCheck = false;
  }

  bool isWatchingVideo = false;
  int i = 0;

  void onSpeechResult(
      SpeechRecognitionResult result, BuildContext context) async {
    lastWords = result.recognizedWords.split(" ").last;
    // int index = gridSizedModel.listData
    //         ?.indexWhere((gridModel) => gridModel.title == lastWords) ??
    //     -1;

    int index = findWordInGrid(lastWords);
    lastWords = "";

    if (index >= 0 && !isWatchingVideo) {
      stopListening();
// Setting this true so the other words will not make further instences of VideoPlayerView.
      isWatchingVideo = true;

      dev.log("Match found at index: $index ${i++}");
      GridModel matchedModel = gridSizedModel.listData?[index] ?? GridModel();
      // Log the matched path
      dev.log("Matched video paths: ${matchedModel.videosPath}");

      if (matchedModel.title != null) {
        await flutterTts.speak(matchedModel.title!);
      }

      if (matchedModel.videosPath != null &&
          matchedModel.videosPath!.isNotEmpty) {
        var rand = Random().nextInt(matchedModel.videosPath?.length ?? 0 + 1);
        dev.log("Navigating to: ${matchedModel.videosPath?[rand]}");
        AppUtility.navigatorKey.currentState?.pushNamed(
          RouteStrings.videoPlayer,
          arguments: {
            'url': matchedModel.videosPath![rand],
            'localUrl': matchedModel.localVideosPath?[rand],
          },
        ).then((_) {
          isWatchingVideo = false;
          setSpeechToText(context);
        });
      } else {
        dev.log("No valid video path found.");
      }
    } else {
      dev.log("No match found for: $lastWords");
    }
  }

  int findWordInGrid(String w) {
    //List<String> words = w.split(' ');
    int index = -1;

    // for (String i in words) {
    if (gridSizedModel.listData != null) {
      index = gridSizedModel.listData!.indexWhere((gridModel) {
        if (gridModel.title?.toLowerCase() == w.toLowerCase() &&
            (gridModel.videosPath?.isNotEmpty ?? false)) {
          return true;
        } else {
          return false;
        }
      });
    }
    // }

    return index;
  }

  ///Text to speech
  FlutterTts _flutterTts = FlutterTts();
  FlutterTts get flutterTts => _flutterTts;

  List<Map> _voices = [];
  List<Map> get ttfVoices => _voices;

  Map? _currentVoice;
  Map? get currentVoice => _currentVoice;

  int? _currentWordStart;
  int? get currentWordStart => _currentWordStart;

  int? _currentWordEnd;
  int? get currentWordEnd => _currentWordEnd;

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    // await flutterTts.setSpeechRate(0.8);
    await flutterTts.setLanguage("en-US");

    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentWordStart = start;
      _currentWordEnd = end;
      notifyListeners();
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);

        // _voices = voices.where((voice) => voice["name"].contains("en")).toList();

// Setting the TTS voice so when ever the user click on a tile it will only say in a english accent.
        _voices = voices;
// Uncomment the code below if you need to allow only en-Local
        // .where((v) {
        //   if (v['locale'].contains('en')) {
        //     // && v['gender'] == 'male'
        //     return true;
        //   }
        //   //  else if (v['locale'] == 'en-US' && v['gender'] == 'female') {
        //   //   return true;
        //   // }
        //   else {
        //     return false;
        //   }
        // }).toList();
        // Try to load voice for current board, fallback to global/default
        final savedVoice = hiveStorage.getData(DBKey.voiceKey);
        _currentVoice = savedVoice != null
            ? jsonDecode(savedVoice)
            : _voices
                .where(
                    (v) => (v['gender'] == 'female' && v['locale'] == 'en-US'))
                .first;

        try {
          setVoice(_currentVoice!).catchError((e) {
            dev.log('Error setting initial voice: $e', name: 'Voice TTS Error');
          });
        } catch (e) {
          dev.log('Error setting initial voice: $e', name: 'Voice TTS Error');
        }

        notifyListeners();
      } catch (e) {
        dev.log('$e', name: 'Voice TTS Error');
      }
    });
  }

  onVoiceTap(Map v, BuildContext context) async {
    try {
      // Stop any ongoing speech before changing voice (important for iPad)
      try {
        await _flutterTts.stop();
        // Wait a bit for TTS to fully stop (important for iPad)
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        // If stop fails, continue anyway
        dev.log('Error stopping TTS: $e', name: 'Voice TTS');
      }

      _currentVoice = v;
      dev.log(v.toString(), name: 'SelectedVoice');

      // Pop navigator before setting voice to avoid context issues
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      await setVoice(v);
    } catch (e) {
      dev.log('Error in onVoiceTap: $e', name: 'Voice TTS Error');
      // Still pop if voice setting fails
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      // Optionally show error to user
    }
  }

  Future<void> setVoice(Map voice) async {
    try {
      // Validate voice data before setting
      if (voice["name"] == null || voice["locale"] == null) {
        dev.log('Invalid voice data: missing name or locale',
            name: 'Voice TTS Error');
        return;
      }

      // Stop any ongoing speech first
      try {
        await _flutterTts.stop();
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        // If stop fails, continue anyway - might not be speaking
        dev.log('TTS stop error (might not be speaking): $e',
            name: 'Voice TTS');
      }

      // Set voice with error handling
      final result = await _flutterTts
          .setVoice({"name": voice["name"], "locale": voice["locale"]});

      if (result == 1) {
        dev.log('Voice set successfully: ${voice["name"]}', name: 'Voice TTS');
        // Save voice per board/page instead of globally
        await _saveVoiceForCurrentBoard(voice);
      } else {
        dev.log('Failed to set voice. Result: $result',
            name: 'Voice TTS Error');
      }
    } catch (e) {
      dev.log('Error setting voice: $e', name: 'Voice TTS Error');
      // Re-throw or handle error as needed
      rethrow;
    }
  }

  // Save voice per board/page
  Future<void> _saveVoiceForCurrentBoard(Map voice) async {
    if (_gridSizedModel.id != null) {
      final voiceKey = '${DBKey.voiceKey}_${_gridSizedModel.id}';
      hiveStorage.putData(voiceKey, jsonEncode(voice));
    }
    // Also save as global fallback
    hiveStorage.putData(DBKey.voiceKey, jsonEncode(voice));
  }

  // Load voice for current board/page
  Future<void> loadVoiceForCurrentBoard() async {
    try {
      Map? voice;

      // Try to load voice for current board first
      if (_gridSizedModel.id != null) {
        final voiceKey = '${DBKey.voiceKey}_${_gridSizedModel.id}';
        final savedVoice = hiveStorage.getData(voiceKey);
        if (savedVoice != null) {
          voice = jsonDecode(savedVoice);
          dev.log(
              'Loaded voice for board ${_gridSizedModel.id}: ${voice?["name"]}',
              name: 'Voice TTS');
        }
      }

      // Fallback to global voice if board-specific not found
      if (voice == null) {
        final savedVoice = hiveStorage.getData(DBKey.voiceKey);
        if (savedVoice != null) {
          voice = jsonDecode(savedVoice);
          dev.log('Loaded global voice: ${voice?["name"]}', name: 'Voice TTS');
        }
      }

      // If still no voice found, use default
      if (voice == null && _voices.isNotEmpty) {
        voice = _voices.firstWhere(
          (v) => (v['gender'] == 'female' && v['locale'] == 'en-US'),
          orElse: () => _voices.first,
        );
      }

      if (voice != null) {
        _currentVoice = voice;
        await setVoice(voice);
      }
    } catch (e) {
      dev.log('Error loading voice for board: $e', name: 'Voice TTS Error');
    }
  }

//   setGridSizedModel(GridSizeModel grid, int index) {
//     _gridSizedModel = grid;
//     _gridIndex = index;

// // setting the borad title so it can be change easily
//     boradTitleController.text = grid.title ?? '';
//     notifyListeners();
//   }

  setLottie() {
    _lottie = true;
    dev.log('$_currentWordStart');
    Future.delayed(const Duration(seconds: 2), () {
      _lottie = false;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> getCurrentSelectedGridSizedModel(
      ContentProvider contentProvider) async {
    await contentProvider.getAllGridSizeModel();
    _gridSizedModel = contentProvider.allGridSizedModel.firstWhere(
        (grid) => grid.currentSelected == true,
        orElse: () => contentProvider.allGridSizedModel.first);

    notifyListeners();
  }

  makeDuplicateGridSizedModel(GridSizeModel gridSizedModel) {
    _duplicateGridSizedModel = gridSizedModel;
    notifyListeners();
  }

  wordsOnlyShowSettings(int index) {
    _settingsWordOnlyShow = index;
    notifyListeners();
  }

  useSpeechFunction() {
    _useSpeech = !_useSpeech;
    notifyListeners();
  }

  Future<void> setHideButton(ContentProvider contentProvider) async {
    dev.log("grid index $_gridIndex");

    if (_gridSizedModel.id != null) {
      for (int i = 0; i < (_gridSizedModel.listData?.length ?? 0); i++) {
        await contentProvider.updateListDataItem(
          itemIndex: i,
          hideTitle: true,
          hideImage: true,
          id: _gridSizedModel.id!,
        );
      }

      // _gridSizedModel = GridSizeModel();  // Resetting the model
      // GridSizeModel gridModel = contentProvider.allGridSizedModel
      //     .firstWhere((element) => element.id == 1);
      //
      // dev.log(gridModel.toJson());

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
    }

    notifyListeners();
  }

  Future<void> showAllButton(ContentProvider contentProvider) async {
    dev.log("grid index $_gridIndex");

    if (_gridSizedModel.id != null) {
      for (int i = 0; i < (_gridSizedModel.listData?.length ?? 0); i++) {
        await contentProvider.updateListDataItem(
          itemIndex: i,
          hideTitle: false,
          hideImage: false,
          id: _gridSizedModel.id!,
        );
      }

      // _gridSizedModel = GridSizeModel();

      // GridSizeModel gridModel = contentProvider.allGridSizedModel
      //     .firstWhere((element) => element.id == _gridIndex);
      //
      // dev.log(gridModel.toJson());

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
    }

    notifyListeners();
  }

  Future<void> deleteBoardButton(
      ContentProvider contentProvider, int index) async {
    dev.log("grid index: $index");

    int? id = contentProvider.allGridSizedModel[index].id;
    dev.log("grid id: $id");

    if (id != null) {
      await contentProvider.deleteGrid(id: id);
      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
    }

    notifyListeners();
  }

  Future<void> hideOrShowEachGrid(
    ContentProvider contentProvider,
    int index, {
    required bool hideImage,
    required bool hideTitle,
  }) async {
    dev.log("grid index model $_gridIndex");
    dev.log("grid index list data $index");

    if (_gridSizedModel.id != null && _editPressedYello) {
      await contentProvider.updateListDataItem(
        itemIndex: index,
        hideImage: hideImage,
        hideTitle: hideTitle,
        id: _gridSizedModel.id!,
      );
      dev.log(contentProvider.allGridSizedModel[_gridIndex].listData![index]
          .toJson()
          .toString());
      dev.log(
          contentProvider.allGridSizedModel[_gridIndex].toJson().toString());

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];

      notifyListeners();
    }

    notifyListeners();
  }

  String _imagePath = "";
  String get imagePath => _imagePath;

  void addVideoToList(String videoPath) {
    _videos.add(videoPath);
    notifyListeners();
  }

  // void removeVideosFromList(int index, int gridIndex, int id, int itemIndex,
  //     ContentProvider contentProvider) {
  //   if (index < 0 || index >= _videos.length) return;
  //   dismissedVideos.add(_videos[index]);
  //   _videos.removeAt(index);
  //   if (_videos.isEmpty) {
  //     dev.log("No videos left, will play only word sound.");
  //   }

  //   contentProvider.updateListDataItem(
  //     id: id,
  //     itemIndex: itemIndex,
  //     videosPath: _videos,
  //   );

  //   setGridSizedModel(contentProvider.allGridSizedModel[gridIndex], gridIndex);

  //   dev.log("Video removed at index $index, remaining: ${_videos.length}");

  //   notifyListeners();
  // }
  // MainDashboardController class ke andar is function ko replace karein

  void removeVideosFromList(
    int index,
    int gridIndex,
    int id,
    int itemIndex,
    ContentProvider contentProvider,
  ) {
    // Safety check
    if (index < 0 || index >= _videos.length) {
      dev.log("Invalid index, cannot remove video.");
      return;
    }

    final String remoteUrlToDelete = _videos[index];
    dev.log("Remote URL to delete: $remoteUrlToDelete");
    String localPathToDelete = "";

    _videos.removeAt(index);

    // Data source (ContentProvider) se bhi local path (agar hai) aur remote path foran remove karein
    final listDataItem =
        contentProvider.allGridSizedModel[gridIndex].listData![itemIndex];

    // Remote URL list se remove karein
    if (listDataItem.videosPath != null &&
        index < listDataItem.videosPath!.length) {
      listDataItem.videosPath!.removeAt(index);
    }

    if (listDataItem.localVideosPath != null &&
        listDataItem.localVideosPath!.isNotEmpty) {
      localPathToDelete = listDataItem.localVideosPath!.firstWhere((element) =>
          p.basename(element) !=
          p.basename(localPathToDelete)); // Path hasil karein
      dev.log("Local path to delete: $localPathToDelete");

      listDataItem.localVideosPath!.removeWhere((element) =>
          p.basename(element) ==
          p.basename(localPathToDelete)); // Remove karein
    }
    notifyListeners();
    _deleteVideoFromStorage(remoteUrlToDelete, localPathToDelete, id,
        contentProvider.allGridSizedModel[gridIndex]);

    dev.log("UI updated instantly. Background deletion started.");
  }

// YEH NAYA HELPER FUNCTION HAI JO BACKGROUND MEIN CHALEGA
  Future<void> _deleteVideoFromStorage(String remoteUrl, String localPath,
      int gridId, GridSizeModel updatedGridModel) async {
    try {
      if (localPath.isNotEmpty) {
        final file = File(localPath);
        if (await file.exists()) {
          await file.delete();
          dev.log("Deleted from local storage.");
        }
      }

      final contentProvider = sl<ContentProvider>();
      await contentProvider.updateGridSizeModelData(
        id: gridId,
        listData: updatedGridModel.listData,
      );
      dev.log("Database updated after background deletion.");

      // Refresh the grid model from database to ensure Find the Word mode has updated data
      // Preserve the current board ID to avoid switching boards
      final currentBoardId = _gridSizedModel.id;
      await contentProvider.getAllGridSizeModel();

      // Find the board with the same ID (not by index, as indices might change)
      if (currentBoardId != null) {
        final refreshedBoardIndex =
            contentProvider.allGridSizedModel.indexWhere(
          (board) => board.id == currentBoardId,
        );

        if (refreshedBoardIndex >= 0) {
          // Update the local model directly without changing board selection
          _gridSizedModel =
              contentProvider.allGridSizedModel[refreshedBoardIndex];
          _gridIndex = refreshedBoardIndex;
          notifyListeners();
          dev.log(
              "Grid model refreshed after video deletion without changing board.");
        } else {
          dev.log(
              "Could not find board with ID $currentBoardId after refresh.");
        }
      }
    } catch (e) {
      dev.log("Error during background deletion: $e");
      // Yahan par error handling kar sakte hain, jaise user ko batana ke delete fail ho gaya
    }
  }

  // Future<void> removeVideosFromList(
  //   int index,
  //   int gridIndex,
  //   int id,
  //   int itemIndex,
  //   ContentProvider contentProvider,
  // ) async {
  //   try {
  //     final listDataItem =
  //         contentProvider.allGridSizedModel[gridIndex].listData![itemIndex];

  //     if (listDataItem.videosPath == null ||
  //         index >= listDataItem.videosPath!.length) {
  //       dev.log(
  //           "Error: Remote video list is null or index is out of bounds. Cannot delete.");
  //       return; // Function ko yahin rok dein
  //     }

  //     final String remoteUrlToDelete = listDataItem.videosPath![index];
  //     String localPathToDelete = "";

  //     if (listDataItem.localVideosPath != null &&
  //         index < listDataItem.localVideosPath!.length) {
  //       localPathToDelete = listDataItem.localVideosPath![index];
  //     }
  //     notifyListeners();

  //     dev.log("Attempting to delete video at index $index...");
  //     dev.log("Remote URL: $remoteUrlToDelete");
  //     dev.log("Local Path (if available): $localPathToDelete");

  //     // Step 4: Local storage se delete karein (agar path valid hai to)
  //     if (localPathToDelete.isNotEmpty) {
  //       final localFile = File(localPathToDelete);
  //       if (await localFile.exists()) {
  //         // Yeh check Invalid Path ke issue ko solve karta hai
  //         await localFile.delete();
  //         dev.log("Local file deleted successfully: $localPathToDelete");
  //       } else {
  //         dev.log(
  //             "Local file not found at path (this is expected after sharing). Skipping delete: $localPathToDelete");
  //       }
  //     }

  //     listDataItem.videosPath!.removeAt(index);
  //     notifyListeners();

  //     // Sirf tab local list se remove karein agar woh valid thi
  //     if (listDataItem.localVideosPath != null &&
  //         index < listDataItem.localVideosPath!.length) {
  //       listDataItem.localVideosPath!.removeAt(index);
  //     }

  //     await contentProvider.updateGridSizeModelData(
  //       id: contentProvider.allGridSizedModel[gridIndex].id!,
  //       listData: contentProvider.allGridSizedModel[gridIndex].listData,
  //     );

  //     // Controller ki state ko update karein
  //     await setGridSizedModel(
  //       contentProvider.allGridSizedModel[gridIndex],
  //       gridIndex,
  //     );
  //     notifyListeners();

  //     dev.log("Cleanup complete. Video reference removed from data source.");
  //   } catch (e) {
  //     dev.log("An unexpected error occurred during video deletion: $e");
  //   }
  // }

  getImagePath(String imagePath) {
    _imagePath = imagePath;

    notifyListeners();
  }

  void toggleBottomSheet() {
    _showBottomSheet = !_showBottomSheet;
    notifyListeners();
  }

  void toggleBottomSheetVideo() {
    _showBottomSheetVideo = !_showBottomSheetVideo;
    notifyListeners();
  }

  void toggleBottomSheetOff() {
    _showBottomSheet = false;
    notifyListeners();
  }

  void toggleBottomSheetOffVideo() {
    _showBottomSheetVideo = false;
    notifyListeners();
  }

  void setEdit(bool value) {
    _editPressedYello = value;
    notifyListeners();
  }

  void setDone(ContentProvider c) {
    _editPressedYello = false;
    _itemClickeBool = false;

// updating boardname
    if (_gridSizedModel.id != null) {
      _gridSizedModel.title = boradTitleController.text.toString();
      c.updateGridSizeModelData(
        id: _gridSizedModel.id ?? 0,
        title: boradTitleController.text,
      );
    }

    // _itemClickedOnEditState=null;
    notifyListeners();
  }

  void setGridSize(int sizeX, int sizeY) {
    _gridSizeX = sizeX;
    _gridSizeY = sizeY;

    notifyListeners();
  }

  void setItemOnEditState(
    int index,
    BuildContext context, {
    required String title,
    required String picture,
    required int id,
    required bool hide,
    required List<String> videoPath,
    required int gridIndex,
  }) {
    if (_editPressedYello) {
      // _itemClickedOnEditState = index;
      _itemClickeBool = true;
      _showBottomSheetVideo = false;
      _showBottomSheet = false;
      _isEditPressed = false;
      _imagePath = '';

      // AppUtility.popOver(
      //   context,
      //   heightSize: context.height,
      //   widthSize: context.width,
      //   EditPopOver(
      //     title: title,
      //     picture: picture,
      //     index: index,
      //     id: id,
      //     gridIndex: gridIndex,
      //     hide: hide,
      //   ),
      // );
// Added new dialog functionality.
      AppUtility.appDialog(
        context,
        child: EditPopOver(
          title: title,
          picture: picture,
          index: index,
          id: id,
          gridIndex: gridIndex,
          hide: hide,
        ),
      );

      dismissedVideos.clear();
      _videos.clear();
      _videos.addAll(videoPath);
      notifyListeners();
    }

    notifyListeners();
  }

  void isEditPressedFun(bool value) {
    _isEditPressed = value;
    notifyListeners();
  }

  void setFindTheWord(bool value) {
    _findTheWord = value;

    notifyListeners();
  }

  Future<void> setRandomIndex() async {
    if (gridSizedModel.listData != null) {
      List<GridModel> l = gridSizedModel.listData!
          .where((a) =>
              a.hideImage == false &&
              a.hidetitle == false &&
              (a.title?.isNotEmpty ?? false))
          .toList();

      if (l.isEmpty) {
        dev.log("No valid items found in gridSizedModel.listData");
        return;
      }

      int i = 0;
      if (l.length > 1) {
        i = Random().nextInt(l.length);
      }
      _randomListIndex = gridSizedModel.listData!.indexWhere((a) {
        if (a.title == l[i].title) return true;
        return false;
      });

      dev.log(_randomListIndex.toString());

      _targetFindWord = l[i].title ?? "";

      await flutterTts.awaitSynthCompletion(true);
      flutterTts.speak("Find $_targetFindWord");
    }

    notifyListeners();
  }

  Future<void> playCorrectSound() async {
    await _playSound("sounds/ding.flac");
  }

  Future<void> speakForWrong() async {
    // await flutterTts.awaitSynthCompletion(true);
    // flutterTts.speak("Find $_targetFindWord");
    await _playSound("sounds/error.wav");
  }

  Future<void> _playSound(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  Future<void> setCurrentIndex() async {
    _targetFindWord = gridSizedModel.listData![_randomListIndex].title ?? "";
    await flutterTts.awaitSynthCompletion(true);
    flutterTts.speak("Find $_targetFindWord");

    notifyListeners();
  }

  void setFindTheWordWrongList(int index) {
    _findTheWordWrongList.add(index);
    notifyListeners();
  }

  void clearFindTheWrongList() {
    _findTheWordWrongList.clear();
    notifyListeners();
  }

  void setFindWordImage(bool value) {
    _findWordImage = value;

    notifyListeners();
  }

  void setFindWordImagePath(String path) {
    _findWordImagePath = path;
    notifyListeners();
  }

  void setFoundSuccess(bool value) {
    _foundSuccess = value;
    notifyListeners();
  }

  void setFreePlayOn(bool value) {
    _freePlay = value;

    notifyListeners();
  }

  void setEditTitleControllerText(String text) {
    editTitleTextEditingController.text = text;
    notifyListeners();
  }

  void clearEditTitleControllerText() {
    if (editTitleTextEditingController.text.isNotEmpty) {
      editTitleTextEditingController.clear();
    }
    notifyListeners();
  }

  bool _isMobile = true;
  bool get isMobile => _isMobile;

  setIsMobile() async {
    _isMobile = await DeviceCheck.isMobile();
    notifyListeners();
  }

  //Ameer Code

  // MainDashboardController class ke andar yeh method add karein ya existing logic ko update karein
  Future<void> duplicateCurrentBoard(
      ContentProvider contentProvider, BuildContext context) async {
    if (_gridSizedModel.id == null) {
      dev.log("No board selected to duplicate.", name: "Duplicate Board");
      return;
    }

    GridSizeModel currentBoardToDuplicate = _gridSizedModel;
    // Ensure `allGridSizedModel` is up-to-date from the database
    await contentProvider.getAllGridSizeModel();

    // Duplicate board ke liye ek unique title generate karein
    String baseTitle = currentBoardToDuplicate.title?.split(' copy ').first ??
        currentBoardToDuplicate.title ??
        "New Board";
    int highestCopyNumber = 0;

    // Existing duplicates ko count karein taaki hum next copy number de sakein (e.g., "Board copy 1", "Board copy 2")
    for (var board in contentProvider.allGridSizedModel) {
      if (board.title?.startsWith(baseTitle) ?? false) {
        final match = RegExp(r' copy (\d+)$').firstMatch(board.title ?? '');
        if (match != null && match.group(1) != null) {
          int? currentCopyNum = int.tryParse(match.group(1)!);
          if (currentCopyNum != null && currentCopyNum > highestCopyNumber) {
            highestCopyNumber = currentCopyNum;
          }
        } else if (board.title == baseTitle) {
          // Original board jiska "copy" suffix nahi hai
          highestCopyNumber = max(highestCopyNumber, 0);
        }
      }
    }
    int newCopyNumber = highestCopyNumber + 1;

    String newBoardTitle = "$baseTitle copy $newCopyNumber";

    // New duplicated board create karein
    GridSizeModel newDuplicatedBoard = GridSizeModel(
      currentSelected: true, // Naya board turant selected ho jaayega
      duplicateCount: newCopyNumber,
      // Deep copy `listData` taaki references share na hon
      listData: currentBoardToDuplicate.listData
          ?.map((item) => GridModel.fromJson(item.toJson()))
          .toList(),
      gridSizeY: currentBoardToDuplicate.gridSizeY,
      gridSizeX: currentBoardToDuplicate.gridSizeX,
      title: newBoardTitle,
      hideModel: currentBoardToDuplicate.hideModel,
      // Baaki saari properties ko bhi copy karein agar GridSizeModel ke constructor mein nahi hain
    );

    // 1. Naye board ko database mein save karein
    await contentProvider.saveGridSizedModel(
        gridSizedModel: newDuplicatedBoard);

    // 2. Refresh the list of all boards from the database to get the ID of the newly saved board
    await contentProvider.getAllGridSizeModel();

    GridSizeModel? savedNewBoard;
    int? savedNewBoardIndex;

    // Naye save kiye gaye board ko `allGridSizedModel` mein find karein
    // Iske liye hum title ka use kar rahe hain, assumption hai ki save hone ke baad title unique hoga
    for (int i = 0; i < contentProvider.allGridSizedModel.length; i++) {
      if (contentProvider.allGridSizedModel[i].title == newBoardTitle &&
          contentProvider.allGridSizedModel[i].id !=
              currentBoardToDuplicate.id) {
        savedNewBoard = contentProvider.allGridSizedModel[i];
        savedNewBoardIndex = i;
        break;
      }
    }

    if (savedNewBoard != null && savedNewBoardIndex != null) {
      // 3. Database mein sabhi boards ki `currentSelected` status ko update karein.
      // Sirf naya duplicated board selected hoga, baaki sab unselected.
      for (int i = 0; i < contentProvider.allGridSizedModel.length; i++) {
        bool shouldBeSelected =
            (contentProvider.allGridSizedModel[i].id == savedNewBoard.id);
        if (contentProvider.allGridSizedModel[i].currentSelected !=
            shouldBeSelected) {
          await contentProvider.updateGridSizeModelData(
            id: contentProvider.allGridSizedModel[i].id!,
            currentSelected: shouldBeSelected,
          );
        }
      }

      // 4. Update kiye gaye `currentSelected` flags ke baad `allGridSizedModel` ko phir se database se refresh karein.
      await contentProvider.getAllGridSizeModel();

      // 5. `MainDashboardController` ki internal state ko naye duplicated board par update karein
      _gridSizedModel = savedNewBoard;
      _gridIndex = savedNewBoardIndex;
      boradTitleController.text = _gridSizedModel.title ??
          ''; // Rename field mein naya title pre-fill karein
      setEdit(true); // Edit mode ko activate karein taaki user rename kar sake
      notifyListeners(); // UI ko update karne ke liye notify karein
    } else {
      dev.log(
          "Failed to locate the newly duplicated board after saving and refreshing.",
          name: "Duplicate Board Error");
      // User ko error message dikhane ka option
    }
  }

  setGridSizedModel(GridSizeModel grid, int index) async {
    final _contentProvider =
        sl<ContentProvider>(); // Make sure ContentProvider is accessible

    // Purane selected board ko unselect karein agar woh naye selected board se alag hai
    if (_gridSizedModel.id != null && _gridSizedModel.id != grid.id) {
      if (_gridSizedModel.currentSelected == true) {
        await _contentProvider.updateGridSizeModelData(
          id: _gridSizedModel.id!,
          currentSelected: false,
        );
      }
    }

    // Naye selected board ko select karein agar woh already selected nahi hai
    if (grid.currentSelected == false) {
      await _contentProvider.updateGridSizeModelData(
        id: grid.id!,
        currentSelected: true,
      );
    }

    // Local state update karein
    _gridSizedModel = grid;
    _gridIndex = index;
    boradTitleController.text =
        grid.title ?? ''; // Edit controller ko update karein

    // Load voice settings for this board/page
    await loadVoiceForCurrentBoard();

    notifyListeners();
  }

  Future<void> shareCurrentBoard(BuildContext context) async {
    if (_gridSizedModel.title == null || _gridSizedModel.listData == null) {
      // User ko message dikhayein ki board khali hai ya save nahi hai
      dev.log("Cannot share an empty or unsaved board.");
      return;
    }

    // Check if there are local files that need to be uploaded
    bool hasLocalFiles = false;
    for (var item in _gridSizedModel.listData ?? []) {
      if (item.imagepath != null &&
          item.imagepath!.isNotEmpty &&
          !item.imagepath!.startsWith('http')) {
        hasLocalFiles = true;
        break;
      }
      if (item.videosPath != null) {
        for (var videoPath in item.videosPath!) {
          if (videoPath.isNotEmpty && !videoPath.startsWith('http')) {
            hasLocalFiles = true;
            break;
          }
        }
        if (hasLocalFiles) break;
      }
    }

    // If there are local files, check internet connection
    if (hasLocalFiles) {
      final hasInternet = await checkInternetConnection();
      if (!hasInternet) {
        AppUtility.snackBar(
          message:
              'Internet connection required to share board with local files',
        );
        return;
      }
    }

    // Show loading dialog immediately
    NavigatorState? dialogNavigator;
    BuildContext? dialogContextRef;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (dialogContext) {
        dialogNavigator = Navigator.of(dialogContext);
        dialogContextRef = dialogContext;
        return Consumer<MainDashboardController>(
          builder: (context, controller, child) {
            return PopScope(
              canPop: false, // Prevent closing by back button
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon Container
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColor.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              controller.uploadProgress > 0
                                  ? Icons.cloud_upload
                                  : Icons.file_present,
                              size: 32,
                              color: AppColor.blue,
                            ),
                          ),
                          const Gap(16),
                          // Title
                          Text(
                            controller.uploadProgress > 0
                                ? 'Uploading Content'
                                : 'Creating Share File',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColor.textBodyColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(8),
                          // Status Text
                          Text(
                            controller.uploadProgress > 0
                                ? 'Uploading content to cloud...\nPlease wait while we process your files'
                                : 'Preparing your board for sharing...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          // Progress Indicator
                          if (controller.uploadProgress > 0) ...[
                            Container(
                              width: double.infinity,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: controller.uploadProgress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.blue,
                                        AppColor.blue.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(8),
                            // Percentage Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(controller.uploadProgress * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColor.blue,
                                      ),
                                ),
                                const Gap(4),
                                Text(
                                  'Complete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // Loading indicator when preparing
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.blue,
                                ),
                              ),
                            ),
                          ],
                          const Gap(16),
                          // Cancel Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                dev.log(
                                    "Cancel button pressed - starting cancellation");
                                controller.cancelUpload();
                                // Close dialog immediately
                                if (dialogContextRef != null) {
                                  Navigator.of(dialogContextRef!).pop();
                                } else if (dialogNavigator != null &&
                                    dialogNavigator!.mounted) {
                                  dialogNavigator!.pop();
                                }
                                dev.log(
                                    "Cancel button - dialog should be closed");
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                side: BorderSide(
                                  color: Colors.grey[400]!,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Close button (X) at top-right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            dev.log(
                                "Close button (X) pressed - starting cancellation");
                            controller.cancelUpload();
                            // Close dialog immediately
                            if (dialogContextRef != null) {
                              Navigator.of(dialogContextRef!).pop();
                            } else if (dialogNavigator != null &&
                                dialogNavigator!.mounted) {
                              dialogNavigator!.pop();
                            }
                            dev.log("Close button - dialog should be closed");
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    try {
      // 1. Pehle loading state set karein
      resetUploadCancellation();
      setIsLoading(true);
      setUploadProgress(0.0);

      // 2. Ek copy banayein board ka taake original data modify na ho
      final boardToShare = GridSizeModel(
        id: _gridSizedModel.id,
        gridSizeX: _gridSizedModel.gridSizeX,
        gridSizeY: _gridSizedModel.gridSizeY,
        title: _gridSizedModel.title,
        hideModel: _gridSizedModel.hideModel,
        listData: _gridSizedModel.listData?.map((item) {
          return GridModel(
            id: item.id,
            title: item.title,
            imagepath: item.imagepath,
            videosPath: item.videosPath != null
                ? List<String>.from(item.videosPath!)
                : null,
            localVideosPath: item.localVideosPath,
            hideImage: item.hideImage,
            hidetitle: item.hidetitle,
          );
        }).toList(),
        duplicateCount: _gridSizedModel.duplicateCount,
        currentSelected: _gridSizedModel.currentSelected,
      );

      // 3. Ab saare local media files ko cloud mein upload karein
      final firebaseService = FirebaseStorageService();
      int totalFiles = 0;
      int uploadedFiles = 0;

      // Count total files to upload
      for (var item in boardToShare.listData ?? []) {
        // Check image
        if (item.imagepath != null &&
            item.imagepath!.isNotEmpty &&
            !item.imagepath!.startsWith('http')) {
          totalFiles++;
        }
        // Check videos
        if (item.videosPath != null) {
          for (var videoPath in item.videosPath!) {
            if (videoPath.isNotEmpty && !videoPath.startsWith('http')) {
              totalFiles++;
            }
          }
        }
      }

      if (totalFiles == 0) {
        // Agar koi local file nahi hai, seedha share kar do
        final boardJson = jsonEncode(boardToShare.toJson());
        final directory = await getTemporaryDirectory();
        final safeTitle =
            _gridSizedModel.title!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
        final filePath = '${directory.path}/$safeTitle.wtdata';
        final file = File(filePath);
        await file.writeAsString(boardJson);

        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin =
            box != null ? box.localToGlobal(Offset.zero) & box.size : null;

        final result = await Share.shareXFiles(
          [XFile(filePath, mimeType: 'application/wtdata')],
          subject: 'Check out this board: ${_gridSizedModel.title}',
          text:
              'I created a board in Word Toob and wanted to share it with you!',
          sharePositionOrigin: sharePositionOrigin,
        );

        setIsLoading(false);
        // Close the loading dialog
        // if (dialogNavigator != null && dialogNavigator!.mounted) {
        //   dialogNavigator!.pop();
        // }
        if (result.status == ShareResultStatus.success) {
          dev.log('Board shared successfully!');
        }
        return;
      }

      // Create a single cancel completer for all uploads
      _uploadCancelCompleter = Completer<void>();
      final cancelCompleter = _uploadCancelCompleter!;

      // Upload all local files
      for (var item in boardToShare.listData ?? []) {
        // Check if cancelled
        if (_isUploadCancelled || cancelCompleter.isCompleted) {
          setIsLoading(false);
          // if (dialogNavigator != null && dialogNavigator!.mounted) {
          //   dialogNavigator!.pop();
          // }
          AppUtility.snackBar(message: 'Upload cancelled');
          return;
        }

        // Upload image if local
        if (item.imagepath != null &&
            item.imagepath!.isNotEmpty &&
            !item.imagepath!.startsWith('http')) {
          final localImageFile =
              File(AppUtility.getFullPathFromFileName(item.imagepath!));
          if (await localImageFile.exists()) {
            final cloudUrl = await firebaseService.uploadFile(
              localImageFile.path,
              'images/${DateTime.now().millisecondsSinceEpoch}_${localImageFile.path.split('/').last}',
              onProgress: (progress) {
                if (_isUploadCancelled || cancelCompleter.isCompleted) {
                  return;
                }
                // Individual file progress + overall progress
                final overallProgress = (uploadedFiles + progress) / totalFiles;
                setUploadProgress(overallProgress);
              },
              cancelToken: cancelCompleter.future,
            );
            if (_isUploadCancelled || cancelCompleter.isCompleted) {
              setIsLoading(false);
              // if (dialogNavigator != null && dialogNavigator!.mounted) {
              //   dialogNavigator!.pop();
              // }
              AppUtility.snackBar(message: 'Upload cancelled');
              return;
            }
            if (cloudUrl != null) {
              item.imagepath = cloudUrl;
              uploadedFiles++;
            }
          }
        }

        // Upload videos if local
        if (item.videosPath != null) {
          final updatedVideos = <String>[];
          for (var videoPath in item.videosPath!) {
            if (_isUploadCancelled || cancelCompleter.isCompleted) {
              setIsLoading(false);
              // if (dialogNavigator != null && dialogNavigator!.mounted) {
              //   dialogNavigator!.pop();
              // }
              AppUtility.snackBar(message: 'Upload cancelled');
              return;
            }
            if (videoPath.isNotEmpty && !videoPath.startsWith('http')) {
              final localVideoFile =
                  File(AppUtility.getFullPathFromFileName(videoPath));
              if (await localVideoFile.exists()) {
                final cloudUrl = await firebaseService.uploadFile(
                  localVideoFile.path,
                  'videos/${DateTime.now().millisecondsSinceEpoch}_${localVideoFile.path.split('/').last}',
                  onProgress: (progress) {
                    if (_isUploadCancelled || cancelCompleter.isCompleted) {
                      return;
                    }
                    final overallProgress =
                        (uploadedFiles + progress) / totalFiles;
                    setUploadProgress(overallProgress);
                  },
                  cancelToken: cancelCompleter.future,
                );
                if (_isUploadCancelled || cancelCompleter.isCompleted) {
                  setIsLoading(false);
                  // if (dialogNavigator != null && dialogNavigator!.mounted) {
                  //   dialogNavigator!.pop();
                  // }
                  AppUtility.snackBar(message: 'Upload cancelled');
                  return;
                }
                if (cloudUrl != null) {
                  updatedVideos.add(cloudUrl);
                  uploadedFiles++;
                } else {
                  updatedVideos.add(videoPath); // Keep original if upload fails
                }
              } else {
                updatedVideos.add(videoPath);
              }
            } else {
              updatedVideos.add(videoPath); // Already a URL
            }
          }
          item.videosPath = updatedVideos;
        }
      }

      // Check if cancelled before finalizing
      if (_isUploadCancelled || cancelCompleter.isCompleted) {
        setIsLoading(false);
        // if (dialogNavigator != null && dialogNavigator!.mounted) {
        //   dialogNavigator!.pop();
        // }
        AppUtility.snackBar(message: 'Upload cancelled');
        return;
      }

      // 4. Ab board ko JSON mein convert karein (ab cloud URLs ke saath)
      final boardJson = jsonEncode(boardToShare.toJson());
      // 2. Ek temporary file banayein
      final directory = await getTemporaryDirectory();
      // File ka naam unique rakhein, jaise board ke title aur ek custom extension ke saath
      // Custom extension (e.g., .wtcard) zaroori hai taaki iOS pehchan sake
      final safeTitle =
          _gridSizedModel.title!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final filePath = '${directory.path}/$safeTitle.wtdata';
      final file = File(filePath);

      // 3. JSON data ko file mein likhein
      await file.writeAsString(boardJson);

      // 4. iOS ke liye sharePositionOrigin calculate karein (iPad par zaroori hai)
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      // 5. share_plus ka istemal karke file ko share karein
      setIsLoading(false);
      // Close the loading dialog before showing share sheet
      if (dialogNavigator != null && dialogNavigator!.mounted) {
        dialogNavigator!.pop();
      }

      final result = await Share.shareXFiles(
        [
          XFile(
            filePath,
            mimeType: 'application/wtdata',
          )
        ],
        subject: 'Check out this board: ${_gridSizedModel.title}',
        text: 'I created a board in Word Toob and wanted to share it with you!',
        sharePositionOrigin: sharePositionOrigin,
      );

      // Sharing ke result ko handle karein (optional)
      if (result.status == ShareResultStatus.success) {
        dev.log('Board shared successfully!');
      }
    } catch (e) {
      setIsLoading(false);
      // Close the loading dialog on error
      if (dialogNavigator != null && dialogNavigator!.mounted) {
        dialogNavigator!.pop();
      }
      dev.log('Error sharing board: $e');
      // User ko error message dikhayein
      if (!_isUploadCancelled) {
        AppUtility.snackBar(message: 'Error sharing board: ${e.toString()}');
      }
    } finally {
      // Reset cancellation flag
      resetUploadCancellation();
    }
  }

  // === YEH LINES ADD KAREIN ===
  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  void setUploadProgress(double value) {
    _uploadProgress = value;
    notifyListeners();
  }
}

/*Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
    await flutterTts.setLanguage("en-US");

    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentWordStart = start;
      _currentWordEnd = end;
      notifyListeners();
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        voices.removeWhere((voice) => voice['name'] == 'Zoe');

        Map<String, List<Map>> groupedVoices = {};
        for (var voice in voices) {
          if (voice['gender'] != 'unspecified') {
            String locale = voice['locale'];
            if (!groupedVoices.containsKey(locale)) {
              groupedVoices[locale] = [];
            }
            groupedVoices[locale]!.add(voice);
          }
        }

        List<Map> filteredVoices = [];
        groupedVoices.forEach((locale, voiceList) {
          Map? maleVoice;
          Map? femaleVoice;

          for (var voice in voiceList) {
            if (voice['gender'] == 'male' && maleVoice == null) {
              maleVoice = voice;
            } else if (voice['gender'] == 'female' && femaleVoice == null) {
              femaleVoice = voice;
            }
          }

          if (maleVoice != null) {
            filteredVoices.add(maleVoice);
          }
          if (femaleVoice != null) {
            filteredVoices.add(femaleVoice);
          }
        });

        _voices = filteredVoices;

        var existingVoice = hiveStorage.getData(DBKey.voiceKey);
        _currentVoice = existingVoice != null
            ? jsonDecode(existingVoice)
            : _voices.firstWhere(
                (v) => v['name'] == 'Nikki',
                orElse: () => _voices.first,
              );

        setVoice(_currentVoice!);

        notifyListeners();
      } catch (e) {
        dev.log('$e', name: 'Voice TTS Error');
      }
    });
  }*/