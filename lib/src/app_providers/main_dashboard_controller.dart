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
import 'package:word_toob/src/views/widgets/edit_pop_over.dart';
import '../common/app_constants/route_strings.dart';
import 'dart:developer' as dev;

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

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsTapped(bool value) {
    _isTapped = value;
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
    notifyListeners();
  }

  double _soundLevel = 0.0;
  double get soundLevel => _soundLevel;

  void startListening(BuildContext context) async {
    if (!speechEnabled) await initSpeechToText();
    if (speechToText.isListening) {
      dev.log('Already listening, ignoring duplicate startListening call.',
          name: 'Microphone');
      return;
    }

    try {
      await speechToText.listen(
        onResult: (result) {
          dev.log(result.recognizedWords);
          if (_speechToTextCheck) {
            onSpeechResult(result, context);
          }
        },
        listenFor: const Duration(seconds: 30),
        //pauseFor: const Duration(seconds: 20),
        // cancelOnError: true,
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
        AppUtility.navigatorKey.currentState
            ?.pushNamed(
          RouteStrings.videoPlayer,
          arguments: matchedModel.videosPath![rand],
        )
            .then((_) {
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
        var existingVoice = hiveStorage.getData(DBKey.voiceKey);
        _currentVoice = existingVoice != null
            ? jsonDecode(existingVoice)
            : _voices
                .where(
                    (v) => (v['gender'] == 'female' && v['locale'] == 'en-US'))
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

    hiveStorage.putData(DBKey.voiceKey, jsonEncode(voice));
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

  void removeVideosFromList(int index, int gridIndex, int id, int itemIndex,
      ContentProvider contentProvider) {
    if (index < 0 || index >= _videos.length) return;
    dismissedVideos.add(_videos[index]);
    _videos.removeAt(index);
    if (_videos.isEmpty) {
      dev.log("No videos left, will play only word sound.");
    }

    contentProvider.updateListDataItem(
      id: id,
      itemIndex: itemIndex,
      videosPath: _videos,
    );

    setGridSizedModel(contentProvider.allGridSizedModel[gridIndex], gridIndex);

    dev.log("Video removed at index $index, remaining: ${_videos.length}");

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
    notifyListeners();
  }

  Future<void> shareCurrentBoard(BuildContext context) async {
    if (_gridSizedModel.title == null || _gridSizedModel.listData == null) {
      // User ko message dikhayein ki board khali hai ya save nahi hai
      dev.log("Cannot share an empty or unsaved board.");
      return;
    }

    try {
      // 1. GridSizeModel ko JSON string mein convert karein
      final boardJson = jsonEncode(_gridSizedModel.toJson());

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
      final result = await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Check out this board: ${_gridSizedModel.title}',
        text: 'I created a board in Word Toob and wanted to share it with you!',
        sharePositionOrigin: sharePositionOrigin,
      );

      // Sharing ke result ko handle karein (optional)
      if (result.status == ShareResultStatus.success) {
        dev.log('Board shared successfully!');
      }
    } catch (e) {
      dev.log('Error sharing board: $e');
      // User ko error message dikhayein
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
