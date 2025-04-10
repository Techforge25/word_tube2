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
import '../common/app_constants/route_strings.dart';
import 'dart:developer' as dev;

class MainDashboardController extends ChangeNotifier {
  TextEditingController editTitleTextEditingController =
      TextEditingController();

  TextEditingController boradTitleController = TextEditingController();

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
    speechEnabled = await speechToText.initialize(
      onStatus: onStatus,
      onError: onError,
    );
    notifyListeners();
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
    speechEnabled = false;
    notifyListeners();
  }

  double _soundLevel = 0.0;
  double get soundLevel => _soundLevel;

  void startListening(BuildContext context) async {
    if (!speechEnabled) initSpeechToText();

    try {
      await speechToText.listen(
        onResult: (result) => onSpeechResult(result, context),
        listenFor: Duration(hours: 50),
        onSoundLevelChange: (level) {
          _soundLevel = level;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('$e', name: 'Microphone Error');
    }

    notifyListeners();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  ///

  void stopListening() async {
    _speechToTextCheck = false;
    await speechToText.stop();
  }

  bool isWatchingVideo = false;

  void onSpeechResult(SpeechRecognitionResult result, BuildContext context) {
    lastWords = result.recognizedWords;

    // int index = gridSizedModel.listData
    //         ?.indexWhere((gridModel) => gridModel.title == lastWords) ??
    //     -1;

    int index = findWordInGrid(lastWords);
    lastWords = "";

    if (index >= 0 && !isWatchingVideo) {
// Setting this true so the other words will not make further instences of VideoPlayerView.
      isWatchingVideo = true;

      dev.log("Match found at index: $index");
      GridModel matchedModel = gridSizedModel.listData?[index] ?? GridModel();
      var rand = Random().nextInt(matchedModel.videosPath?.length ?? 0 + 1);

      Navigator.pushNamed(
        context,
        RouteStrings.videoPlayer,
        arguments: matchedModel.videosPath?[rand],
      );
    } else {
      dev.log("No match found for: $lastWords");
    }
  }

  int findWordInGrid(String w) {
    List<String> words = w.split(' ');
    int index = -1;

    for (String i in words) {
      if (gridSizedModel.listData != null) {
        index = gridSizedModel.listData!.indexWhere((gridModel) {
          if (gridModel.title == i &&
              (gridModel.videosPath?.isNotEmpty ?? false)) {
            return true;
          } else {
            return false;
          }
        });
      }
    }

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

        // _voices = voices.where((voice) => voice["name"].contains("en")).toList();

// Setting the TTS voice so when ever the user click on a tile it will only say in a english accent.
        _voices = voices.where((v) {
          if (v['locale'].contains('en')) {
            // && v['gender'] == 'male'
            return true;
          }
          //  else if (v['locale'] == 'en-US' && v['gender'] == 'female') {
          //   return true;
          // }
          else {
            return false;
          }
        }).toList();

        _currentVoice = _voices
            .where((v) => (v['gender'] == 'female' && v['locale'] == 'en-US'))
            .first;
        setVoice(_currentVoice!);

        notifyListeners();
      } catch (e) {
        dev.log('$e', name: 'Voice TTS Error');
      }
    });
  }

  onVoiceTap(Map v, BuildContext context) async {
    _currentVoice = v;
    dev.log(v.toString(), name: 'SelectedVoice');
    Navigator.pop(context);
    await setVoice(v);
  }

  Future<void> setVoice(Map voice) async {
    await _flutterTts
        .setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  setGridSizedModel(GridSizeModel grid, int index) {
    _gridSizedModel = grid;
    _gridIndex = index;

// setting the borad title so it can be change easily
    boradTitleController.text = grid.title ?? '';
    notifyListeners();
  }

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
      await contentProvider.deleteGrid(id: _gridSizedModel.id!);
      _gridSizedModel = contentProvider.allGridSizedModel[_gridIndex];
      dev.log(_gridSizedModel.toString());
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

  void removeVideosFromList(int index) {
    dismissedVideos.add(_videos[index]);
    _videos.removeAt(index);
    dev.log('$index');
    notifyListeners();
  }

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
    _randomListIndex = Random().nextInt(gridSizedModel.listData!.length - 1);
    _targetFindWord = gridSizedModel.listData?[_randomListIndex].title ?? "";
    await flutterTts.awaitSynthCompletion(true);
    flutterTts.speak("Find $_targetFindWord");

    notifyListeners();
  }

  Future<void> speakForWrong() async {
    await flutterTts.awaitSynthCompletion(true);
    flutterTts.speak("Find $_targetFindWord");
  }

  Future<void> setCurrentIndex() async {
    _targetFindWord = gridSizedModel.listData?[_randomListIndex].title ?? "";
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
}
