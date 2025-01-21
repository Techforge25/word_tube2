// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:word_toob/src/common/app_constants/app_strings.dart';

import '../../source/models/grid_model.dart';
import '../../source/models/grid_size_model.dart';
import 'assets.dart';

/// Logging config
const kLOG_TAG = "[${AppString.appName}]";
const kLOG_ENABLE = kDebugMode;

void printLog(dynamic data) {
  if (kLOG_ENABLE) {
    log("$kLOG_TAG ${data.toString()}");
  }
}

List<GridSizeModel> gridModelList = [
  ///emotions
  GridSizeModel(
      title: AppString.emotions,
      gridSizeX: 4,
      gridSizeY: 4,
      hideModel: false,
      listData: [
        GridModel(
            title: AppString.happy,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.happyP,
            videosPath: [MyAssets.happyVideo1, MyAssets.happyVideo2]),
        GridModel(
            title: AppString.love,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.love,
            videosPath: [MyAssets.love1, MyAssets.love2]),
        GridModel(
            title: AppString.excited,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.excited,
            videosPath: [MyAssets.excited1, MyAssets.excited2]),
        GridModel(
            title: AppString.surprised,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.surprised,
            videosPath: [MyAssets.surprised1, MyAssets.surprised2]),
        GridModel(
            title: AppString.scared,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.scared,
            videosPath: [MyAssets.scared1, MyAssets.scared2]),
        GridModel(
            title: AppString.frustrated,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.frustrated,
            videosPath: [MyAssets.frustrated1, MyAssets.frustrated2]),
        GridModel(
            title: AppString.mad,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.mad,
            videosPath: [MyAssets.mad1, MyAssets.mad2]),
        GridModel(
            title: AppString.sad,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.sad,
            videosPath: [MyAssets.sad1, MyAssets.sad2]),
      ]),

  ///First 25 words
  GridSizeModel(
      title: AppString.first25Words,
      gridSizeX: 5,
      gridSizeY: 5,
      hideModel: false,
      listData: [
        GridModel(
            title: AppString.mommy,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.mommy,
            videosPath: []),
        GridModel(
            title: AppString.yes,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.yes,
            videosPath: []),
        GridModel(
            title: AppString.bye,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bye,
            videosPath: []),
        GridModel(
            title: AppString.hello,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hello,
            videosPath: []),
        GridModel(
            title: AppString.no,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.no,
            videosPath: []),
        GridModel(
            title: AppString.eye,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.eye,
            videosPath: []),
        GridModel(
            title: AppString.ball,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.ball,
            videosPath: []),
        GridModel(
            title: AppString.thankYou,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.thankYou,
            videosPath: []),
        GridModel(
            title: AppString.book,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.book,
            videosPath: []),
        GridModel(
            title: AppString.nose,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.nose,
            videosPath: []),
        GridModel(
            title: AppString.daddy,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.daddy,
            videosPath: []),
        GridModel(
            title: AppString.cookie,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cookie,
            videosPath: []),
        GridModel(
            title: AppString.hat,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hat,
            videosPath: []),
        GridModel(
            title: AppString.shoe,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.shoe,
            videosPath: []),
        GridModel(
            title: AppString.more,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.more,
            videosPath: []),
        GridModel(
            title: AppString.cat,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cat,
            videosPath: []),
        GridModel(
            title: AppString.dog,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.dog,
            videosPath: []),
        GridModel(
            title: AppString.baby,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.baby,
            videosPath: []),
        GridModel(
            title: AppString.car,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.car,
            videosPath: []),
        GridModel(
            title: AppString.bath,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bath,
            videosPath: []),
        GridModel(
            title: AppString.allGone,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.allGone,
            videosPath: []),
        GridModel(
            title: AppString.bananan,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.banana,
            videosPath: []),
        GridModel(
            title: AppString.milk,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.milk,
            videosPath: []),
        GridModel(
            title: AppString.juice,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.juice,
            videosPath: []),
        GridModel(
            title: AppString.hot,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hot,
            videosPath: []),
      ]),

  ///Alphabets
  GridSizeModel(
      title: AppString.alphabetBoard,
      gridSizeX: 5,
      gridSizeY: 6,
      hideModel: false,
      listData: [
        GridModel(
            title: AppString.a,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.a,
            videosPath: []),
        GridModel(
            title: AppString.b,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.b,
            videosPath: []),
        GridModel(
            title: AppString.c,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.c,
            videosPath: []),
        GridModel(
            title: AppString.d,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.d,
            videosPath: []),
        GridModel(
            title: AppString.e,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.e,
            videosPath: []),
        GridModel(
            title: AppString.f,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.f,
            videosPath: []),
        GridModel(
            title: AppString.g,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.g,
            videosPath: []),
        GridModel(
            title: AppString.h,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.h,
            videosPath: []),
        GridModel(
            title: AppString.i,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.i,
            videosPath: []),
        GridModel(
            title: AppString.j,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.j,
            videosPath: []),
        GridModel(
            title: AppString.k,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.k,
            videosPath: []),
        GridModel(
            title: AppString.l,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.l,
            videosPath: []),
        GridModel(
            title: AppString.m,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.m,
            videosPath: []),
        GridModel(
            title: AppString.n,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.n,
            videosPath: []),
        GridModel(
            title: AppString.o,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.o,
            videosPath: []),
        GridModel(
            title: AppString.p,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.p,
            videosPath: []),
        GridModel(
            title: AppString.q,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.q,
            videosPath: []),
        GridModel(
            title: AppString.r,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.r,
            videosPath: []),
        GridModel(
            title: AppString.s,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.s,
            videosPath: []),
        GridModel(
            title: AppString.t,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.t,
            videosPath: []),
        GridModel(
            title: AppString.u,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.u,
            videosPath: []),
        GridModel(
            title: AppString.v,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.v,
            videosPath: []),
        GridModel(
            title: AppString.w,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.w,
            videosPath: []),
        GridModel(
            title: AppString.x,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.x,
            videosPath: []),
        GridModel(
            title: AppString.y,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.y,
            videosPath: []),
        GridModel(
            title: AppString.z,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.z,
            videosPath: []),
      ]),

  ///numbers
  GridSizeModel(
      title: AppString.numbers,
      gridSizeX: 5,
      gridSizeY: 5,
      hideModel: false,
      listData: [
        GridModel(
            title: AppString.zero,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.zero,
            videosPath: []),
        GridModel(
            title: AppString.one,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.one,
            videosPath: []),
        GridModel(
            title: AppString.two,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.two,
            videosPath: []),
        GridModel(
            title: AppString.three,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.three,
            videosPath: []),
        GridModel(
            title: AppString.four,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.four,
            videosPath: []),
        GridModel(
            title: AppString.five,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.five,
            videosPath: []),
        GridModel(
            title: AppString.six,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.six,
            videosPath: []),
        GridModel(
            title: AppString.seven,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.seven,
            videosPath: []),
        GridModel(
            title: AppString.eight,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.eight,
            videosPath: []),
        GridModel(
            title: AppString.nine,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.nine,
            videosPath: []),
        GridModel(
            title: AppString.ten,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.ten,
            videosPath: []),
      ]),
];
