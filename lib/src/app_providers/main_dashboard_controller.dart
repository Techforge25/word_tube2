// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/func/device_check.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/views/widgets/edit_pop_over.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';

import 'dart:developer' as dev;

class MainDashboardController extends ChangeNotifier {
  // ==================== TEXT CONTROLLERS ====================
  final TextEditingController editTitleTextEditingController =
      TextEditingController();
  final TextEditingController boradTitleController = TextEditingController();

  // ==================== GRID SIZE PROPERTIES ====================
  int _gridSizeX = 1;
  int get gridSizeX => _gridSizeX;

  int _gridSizeY = 2;
  int get gridSizeY => _gridSizeY;

  // ==================== EDIT STATE PROPERTIES ====================
  bool _editPressedYello = false;
  bool get editPressedYello => _editPressedYello;

  int? _itemClickedOnEditState;
  int? get itemClickedOnEditState => _itemClickedOnEditState;

  bool _itemClickeBool = false;
  bool get itemClickeBool => _itemClickeBool;

  // ==================== BOTTOM SHEET PROPERTIES ====================
  bool _showBottomSheet = false;
  bool get showBottomSheet => _showBottomSheet;

  bool _showBottomSheetVideo = false;
  bool get showBottomSheetVideo => _showBottomSheetVideo;

  bool _isEditPressed = false;
  bool get isEditPressed => _isEditPressed;

  // ==================== SETTINGS PROPERTIES ====================
  int _settingsWordOnlyShow = 1;
  int get settingsWordOnlyShow => _settingsWordOnlyShow;

  int _gridIndex = 0;
  int get gridIndex => _gridIndex;

  // ==================== SPEECH AND INTERACTION PROPERTIES ====================
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

  int _randomListIndex = 0;
  int get randomListIndex => _randomListIndex;

  // ==================== VIDEO PROPERTIES ====================
  List<String> _videos = [];
  List<String> get videos => _videos;

  List<String> dismissedVideos = [];
  List<String> get visibleVideos =>
      _videos.where((video) => !dismissedVideos.contains(video)).toList();

  // ==================== GRID DATA PROPERTIES ====================
  List<GridModel> _gridItemMain = [];
  List<GridModel> get gridItemMain => _gridItemMain;

  GridSizeModel _gridSizedModel = GridSizeModel();
  GridSizeModel get gridSizedModel => _gridSizedModel;

  GridSizeModel _duplicateGridSizedModel = GridSizeModel();
  GridSizeModel get duplicateGridSizedModel => _duplicateGridSizedModel;

  List<int> _findTheWordWrongList = [];
  List<int> get findTheWordWrongList => _findTheWordWrongList;

  // ==================== SPEECH TO TEXT PROPERTIES ====================
  bool _speechToTextCheck = false;
  bool get speechToTextCheck => _speechToTextCheck;

  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  double _soundLevel = 0.0;
  double get soundLevel => _soundLevel;

  // ==================== TEXT TO SPEECH PROPERTIES ====================
  final FlutterTts _flutterTts = FlutterTts();
  FlutterTts get flutterTts => _flutterTts;

  List<Map> _voices = [];
  List<Map> get ttfVoices => _voices;

  Map? _currentVoice;
  Map? get currentVoice => _currentVoice;

  int? _currentWordStart;
  int? get currentWordStart => _currentWordStart;

  int? _currentWordEnd;
  int? get currentWordEnd => _currentWordEnd;

  // ==================== VIDEO WATCHING STATE ====================
  bool isWatchingVideo = false;
  int i = 0;

  // ==================== IMAGE PATH ====================
  String _imagePath = "";
  String get imagePath => _imagePath;

  // ==================== DEVICE TYPE ====================
  bool _isMobile = true;
  bool get isMobile => _isMobile;

  // ==================== PUBLIC METHODS ====================

  void setRandomListIndex(int i) => _randomListIndex = i;

  void setSpeechToText(BuildContext context) {
    _speechToTextCheck = !_speechToTextCheck;
    if (_speechToTextCheck) {
      startListening(context);
    } else {
      stopListening();
    }
    notifyListeners();
  }

  void setEdit(bool value) {
    _editPressedYello = value;
    notifyListeners();
  }

  void setDone(ContentProvider c) {
    _editPressedYello = false;
    _itemClickeBool = false;

    // Update board name
    if (_gridSizedModel.id != null) {
      _gridSizedModel.title = boradTitleController.text.toString();
      c.updateGridSizeModelData(
        id: _gridSizedModel.id ?? 0,
        title: boradTitleController.text,
      );
    }

    notifyListeners();
  }

  void setGridSize(int sizeX, int sizeY) {
    _gridSizeX = sizeX;
    _gridSizeY = sizeY;
    notifyListeners();
  }

  void setGridSizedModel(GridSizeModel grid, int index) {
    _gridSizedModel = grid;
    _gridIndex = index;

    // Set board title for easy editing
    boradTitleController.text = grid.title ?? '';
    notifyListeners();
  }

  void setLottie() {
    _lottie = true;
    dev.log('$_currentWordStart');
    Future.delayed(const Duration(seconds: 2), () {
      _lottie = false;
      notifyListeners();
    });
    notifyListeners();
  }

  void makeDuplicateGridSizedModel(GridSizeModel gridSizedModel) {
    _duplicateGridSizedModel = gridSizedModel;
    notifyListeners();
  }

  void wordsOnlyShowSettings(int index) {
    _settingsWordOnlyShow = index;
    notifyListeners();
  }

  void useSpeechFunction() {
    _useSpeech = !_useSpeech;
    notifyListeners();
  }

  void setFindTheWord(bool value) {
    _findTheWord = value;
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

  void isEditPressedFun(bool value) {
    _isEditPressed = value;
    notifyListeners();
  }

  void addVideoToList(String videoPath) {
    _videos.add(videoPath);
    notifyListeners();
  }

  void removeVideosFromList(int index) {
    dismissedVideos.add(_videos[index]);
    _videos.removeAt(index);
    dev.log('$index');
    notifyListeners();
  }

  void getImagePath(String imagePath) {
    _imagePath = imagePath;
    notifyListeners();
  }

  // ==================== SPEECH TO TEXT METHODS ====================

  Future<void> initSpeechToText() async {
    try {
      speechEnabled = await speechToText.initialize(
        onError: (SpeechRecognitionError error) {
          dev.log('onError: $error');
        },
        onStatus: (String status) {
          dev.log('onStatus: $status');
        },
      );
    } catch (e) {
      dev.log('Speech to text initialization error: $e');
    }
  }

  Future<void> startListening(BuildContext context) async {
    if (!speechEnabled) {
      dev.log('Speech not enabled');
      return;
    }

    try {
      await speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          onSpeechResult(result, context);
        },
        listenFor: Duration(hours: 50),
        onSoundLevelChange: (level) {
          _soundLevel = level;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error starting speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await speechToText.stop();
    } catch (e) {
      dev.log('Error stopping speech recognition: $e');
    }
  }

  void onSpeechResult(
      SpeechRecognitionResult result, BuildContext context) async {
    lastWords = result.recognizedWords.split(" ").last;
    int index = findWordInGrid(lastWords);

    if (index != -1) {
      GridModel matchedModel = _gridSizedModel.listData![index];
      dev.log("Matched video paths: ${matchedModel.videosPath}");

      if (matchedModel.videosPath != null &&
          matchedModel.videosPath!.isNotEmpty) {
        var rand = Random().nextInt(matchedModel.videosPath?.length ?? 0 + 1);
        dev.log("Navigating to: ${matchedModel.videosPath?[rand]}");
        AppUtility.navigatorKey.currentState
            ?.pushNamed(
          RouteStrings.videoPlayer,
          arguments: matchedModel.videosPath![rand],
        )
            .then((_) {
          isWatchingVideo = false;
        });
      } else {
        dev.log("No video available for matched word");
      }
    } else {
      dev.log("Word not found in grid: $lastWords");
    }
  }

  int findWordInGrid(String word) {
    if (_gridSizedModel.listData == null) return -1;

    for (int i = 0; i < _gridSizedModel.listData!.length; i++) {
      if (_gridSizedModel.listData![i].title?.toLowerCase() ==
          word.toLowerCase()) {
        return i;
      }
    }
    return -1;
  }

  // ==================== TEXT TO SPEECH METHODS ====================

  Future<void> initTextToSpeech() async {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      dev.log("TTS Started");
    });

    _flutterTts.setCompletionHandler(() {
      dev.log("TTS Completed");
    });

    _flutterTts.setErrorHandler((msg) {
      dev.log("TTS Error: $msg");
    });

    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentWordStart = start;
      _currentWordEnd = end;
      notifyListeners();
    });

    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        if (_voices.isNotEmpty) {
          _currentVoice = _voices.first;
        }
      } catch (e) {
        dev.log('Error parsing voices: $e');
      }
    });
  }

  void onVoiceTap(Map voice, BuildContext context) async {
    _currentVoice = voice;
    dev.log('Selected voice: ${voice.toString()}');
    Navigator.pop(context);
    await setVoice(voice);
    notifyListeners();
  }

  Future<void> setVoice(Map voice) async {
    await _flutterTts
        .setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  // ==================== GRID MANAGEMENT METHODS ====================

  Future<void> getCurrentSelectedGridSizedModel(
      ContentProvider contentProvider) async {
    await contentProvider.getAllGridSizeModel();
    _gridSizedModel = contentProvider.allGridSizedModel.firstWhere(
      (element) => element.currentSelected == true,
      orElse: () => contentProvider.allGridSizedModel.first,
    );
    notifyListeners();
  }

  Future<void> deleteBoardButton(
      ContentProvider contentProvider, int index) async {
    dev.log("grid index: $index");

    if (_gridSizedModel.listData != null &&
        index < _gridSizedModel.listData!.length) {
      await contentProvider.updateListDataItem(
        id: _gridSizedModel.id!,
        itemIndex: index,
        hideImage: true,
        hideTitle: true,
      );

      dev.log(contentProvider.allGridSizedModel[_gridIndex].listData![index]
          .toJson()
          .toString());
      dev.log(
          contentProvider.allGridSizedModel[_gridIndex].toJson().toString());

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
      notifyListeners();
    }
  }

  /// Hide or show individual grid items
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

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
      notifyListeners();
    }
  }

  /// Hide all grid items
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

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
      notifyListeners();
    }
  }

  /// Show all grid items
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

      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
      notifyListeners();
    }
  }

  /// Set item for editing state
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
      _itemClickeBool = true;
      _showBottomSheetVideo = false;
      _showBottomSheet = false;
      _isEditPressed = false;
      _imagePath = '';

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

      _videos.clear();
      _videos.addAll(videoPath);
      notifyListeners();
    }
  }

  void setRandomIndex() {
    if (_gridSizedModel.listData != null &&
        _gridSizedModel.listData!.isNotEmpty) {
      _randomListIndex = Random().nextInt(_gridSizedModel.listData!.length);
      _targetFindWord = _gridSizedModel.listData![_randomListIndex].title ?? '';
      notifyListeners();
    }
  }

  void setCurrentIndex() {
    if (_gridSizedModel.listData != null &&
        _gridSizedModel.listData!.isNotEmpty) {
      _targetFindWord = _gridSizedModel.listData![_randomListIndex].title ?? '';
      notifyListeners();
    }
  }

  void speakForWrong() {
    if (_useSpeech) {
      _flutterTts.speak("Try again");
    }
  }

  void setIsMobile() {
    DeviceCheck.isMobile().then((value) {
      _isMobile = value;
      notifyListeners();
    });
  }

  // ==================== CLEANUP ====================

  @override
  void dispose() {
    editTitleTextEditingController.dispose();
    boradTitleController.dispose();
    super.dispose();
  }
}
