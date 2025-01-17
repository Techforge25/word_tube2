import 'package:isar/isar.dart';

part 'grid_local.g.dart';



@collection
class GridLocal {
  Id id = Isar.autoIncrement;


  String? title;
  String? imagepath;
  List<String>? videosPath;
  bool? hideImage;
  bool? hidetitle;

}