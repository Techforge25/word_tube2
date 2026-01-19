// ignore_for_file: unnecessary_getters_setters
import 'package:isar/isar.dart';

/// Model representing a grid item with title, image, videos, and visibility settings
@embedded
class GridModel {
  int? _id;
  String? _title;
  String? _imagepath;
  List<String>? _videosPath;
  List<String>? _localVideosPath;
  bool? _hideImage;
  bool? _hidetitle;

  GridModel({
    String? title,
    String? imagepath,
    List<String>? videosPath,
    List<String>? localVideosPath,
    bool? hideImage,
    bool? hidetitle,
    int? id,
  })  : _title = title,
        _id = id,
        _imagepath = imagepath,
        _videosPath = videosPath,
        _localVideosPath = localVideosPath,
        _hideImage = hideImage,
        _hidetitle = hidetitle;

  // Getters
  String? get title => _title;
  String? get imagepath => _imagepath;
  List<String>? get videosPath => _videosPath;
  List<String>? get localVideosPath => _localVideosPath;
  bool? get hideImage => _hideImage;
  bool? get hidetitle => _hidetitle;
  int? get id => _id;

  // Setters
  set title(String? value) {
    _title = value;
  }

  set imagepath(String? value) {
    _imagepath = value;
  }

  set videosPath(List<String>? value) {
    _videosPath = value;
  }

  set localVideosPath(List<String>? value) {
    _localVideosPath = value;
  }

  set hideImage(bool? value) {
    _hideImage = value;
  }

  set hidetitle(bool? value) {
    _hidetitle = value;
  }

  set setId(int? id) {
    _id = id;
  }

  /// Create a GridModel from JSON data
  factory GridModel.fromJson(Map<String, dynamic> json) {
    return GridModel(
      title: json['title'],
      imagepath: json['imagepath'],
      videosPath: json['videosPath'] != null
          ? List<String>.from(json['videosPath'])
          : null,
      localVideosPath: json['localVideosPath'] != null
          ? List<String>.from(json['localVideosPath'])
          : null,
      hideImage: json['hideImage'],
      hidetitle: json['hidetitle'],
      id: json['id'],
    );
  }

  /// Convert GridModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'title': _title,
      'imagepath': _imagepath,
      'videosPath': _videosPath,
      'localVideosPath': _localVideosPath,
      'hideImage': _hideImage,
      'hidetitle': _hidetitle,
      'id': _id,
    };
  }
}
