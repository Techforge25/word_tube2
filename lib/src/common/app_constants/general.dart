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
  ///colors
  GridSizeModel(
      title: AppString.colors,
      gridSizeX: 3,
      gridSizeY: 4,
      hideModel: false,
      duplicateCount: 1,
      currentSelected: false,
      listData: [
        GridModel(
            title: AppString.red,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.red,
            videosPath: [MyAssets.redVideo]),
        GridModel(
            title: AppString.orange,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.orange,
            videosPath: [MyAssets.orangeVideo]),
        GridModel(
            title: AppString.yellow,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.yellow,
            videosPath: [MyAssets.yellowVideo]),
        GridModel(
            title: AppString.green,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.green,
            videosPath: [MyAssets.greenVideo]),
        GridModel(
            title: AppString.blue,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.blue,
            videosPath: [MyAssets.blueVideo]),
        GridModel(
            title: AppString.purple,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.purple,
            videosPath: [MyAssets.purpleVideo]),
        GridModel(
            title: AppString.pink,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.pink,
            videosPath: [MyAssets.pinkVideo]),
        GridModel(
            title: AppString.brown,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.brown,
            videosPath: [MyAssets.brownVideo]),
        GridModel(
            title: AppString.black,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.black,
            videosPath: [MyAssets.blackVideo]),
        GridModel(
            title: AppString.gray,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.grey,
            videosPath: [MyAssets.grayVideo]),
        GridModel(
            title: AppString.white,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.white,
            videosPath: [MyAssets.whiteVideo]),
        GridModel(
            title: AppString.rainbow,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.rainbow,
            videosPath: [MyAssets.rainbowVideo]),
      ]),

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
            videosPath: [
              MyAssets.happyVideo0,
              MyAssets.happyVideo1,
              MyAssets.happyVideo2
            ],
            localVideosPath: null,
            id: null),
        GridModel(
            title: AppString.love,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.love,
            localVideosPath: null,
            id: null,
            videosPath: [MyAssets.love0, MyAssets.love1, MyAssets.love2]),
        GridModel(
            title: AppString.excited,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.excited,
            localVideosPath: null,
            id: null,
            videosPath: [
              MyAssets.excited0,
              MyAssets.excited1,
              MyAssets.excited2
            ]),
        GridModel(
            title: AppString.surprised,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.surprised,
            localVideosPath: null,
            id: null,
            videosPath: [
              MyAssets.surprised0,
              MyAssets.surprised1,
              MyAssets.surprised2
            ]),
        GridModel(
            title: AppString.scared,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.scared,
            localVideosPath: null,
            id: null,
            videosPath: [MyAssets.scared0, MyAssets.scared1, MyAssets.scared2]),
        GridModel(
            title: AppString.frustrated,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.frustrated,
            videosPath: [
              MyAssets.frustrated0,
              MyAssets.frustrated1,
              MyAssets.frustrated2
            ]),
        GridModel(
            title: AppString.mad,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.mad,
            videosPath: [MyAssets.mad0, MyAssets.mad1, MyAssets.mad2]),
        GridModel(
            title: AppString.sad,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.sad,
            videosPath: [MyAssets.sad0, MyAssets.sad1, MyAssets.sad2]),
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
            videosPath: [MyAssets.mommyVideo]),
        GridModel(
            title: AppString.yes,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.yes,
            videosPath: [MyAssets.yesVideo]),
        GridModel(
            title: AppString.bye,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bye,
            videosPath: [MyAssets.byeVideo]),
        GridModel(
            title: AppString.hello,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hello,
            videosPath: [MyAssets.helloVideo]),
        GridModel(
            title: AppString.noFirst25Word,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.no,
            videosPath: [MyAssets.noVideo]),
        GridModel(
            title: AppString.eye,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.eye,
            videosPath: [MyAssets.eyeVideo]),
        GridModel(
            title: AppString.ball,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.ball,
            videosPath: [MyAssets.ballVideo]),
        GridModel(
            title: AppString.thankYou,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.thankYou,
            videosPath: [MyAssets.thankYouVideo]),
        GridModel(
            title: AppString.book,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.book,
            videosPath: [MyAssets.bookVideo]),
        GridModel(
            title: AppString.nose,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.nose,
            videosPath: [MyAssets.noseVideo]),
        GridModel(
            title: AppString.daddy,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.daddy,
            videosPath: [MyAssets.daddyVideo]),
        GridModel(
            title: AppString.cookie,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cookie,
            videosPath: [MyAssets.cookieVideo]),
        GridModel(
            title: AppString.hat,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hat,
            videosPath: [MyAssets.hatVideo]),
        GridModel(
            title: AppString.shoe,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.shoe,
            videosPath: [MyAssets.shoeVideo, MyAssets.shoeVideo2]),
        GridModel(
            title: AppString.more,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.more,
            videosPath: [MyAssets.moreVideo]),
        GridModel(
            title: AppString.cat,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cat,
            videosPath: [MyAssets.catVideo]),
        GridModel(
            title: AppString.dog,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.dog,
            videosPath: [MyAssets.dogVideo]),
        GridModel(
            title: AppString.baby,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.baby,
            videosPath: [MyAssets.babyVideo]),
        GridModel(
            title: AppString.car,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.car,
            videosPath: [MyAssets.carVideo]),
        GridModel(
            title: AppString.bath,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bath,
            videosPath: [MyAssets.bathVideo]),
        GridModel(
            title: AppString.allGone,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.allGone,
            videosPath: [MyAssets.allGoneVideo, MyAssets.allGoneVideo2]),
        GridModel(
            title: AppString.bananan,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.banana,
            videosPath: [MyAssets.bananaVideo]),
        GridModel(
            title: AppString.milk,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.milk,
            videosPath: [MyAssets.milkVideo]),
        GridModel(
            title: AppString.juice,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.juice,
            videosPath: [MyAssets.juiceVideo]),
        GridModel(
            title: AppString.hot,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hot,
            videosPath: [MyAssets.hotVideo]),
      ]),

  ///First 25 Words Espanol

  GridSizeModel(
      title: AppString.first25WordsEsp,
      gridSizeX: 5,
      gridSizeY: 5,
      hideModel: false,
      listData: [
        GridModel(
            title: AppString.mommyEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.mommy,
            videosPath: [MyAssets.mommyVideo]),
        GridModel(
            title: AppString.yesEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.yes,
            videosPath: [MyAssets.yesVideo]),
        GridModel(
            title: AppString.byeEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bye,
            videosPath: [
              MyAssets.byeVideo,
              MyAssets.byeVideo2,
              MyAssets.byeVideo3,
            ]),
        GridModel(
            title: AppString.helloEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hello,
            videosPath: [MyAssets.helloVideo, MyAssets.helloVideo2]),
        GridModel(
            title: AppString.noFirst25WordEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.no,
            videosPath: [MyAssets.noVideo]),
        GridModel(
            title: AppString.eyeEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.eye,
            videosPath: [
              MyAssets.eyeVideo,
              MyAssets.eyeVideo2,
              MyAssets.eyeVideo3
            ]),
        GridModel(
            title: AppString.ballEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.ball,
            videosPath: [
              MyAssets.ballVideo,
              MyAssets.ballVideo2,
              MyAssets.ballVideo3
            ]),
        GridModel(
            title: AppString.thankYouEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.thankYou,
            videosPath: [
              MyAssets.thankYouVideo,
              MyAssets.thankYouVideo2,
              MyAssets.thankYouVideo3,
            ]),
        GridModel(
            title: AppString.bookEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.book,
            videosPath: [
              MyAssets.bookVideo,
              MyAssets.bookVideo2,
              MyAssets.bookVideo3,
            ]),
        GridModel(
            title: AppString.noseEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.nose,
            videosPath: [
              MyAssets.noseVideo,
              MyAssets.noseVideo2,
              MyAssets.noseVideo3,
            ]),
        GridModel(
            title: AppString.daddyEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.daddy,
            videosPath: [MyAssets.daddyVideo]),
        GridModel(
            title: AppString.cookieEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cookie,
            videosPath: [
              MyAssets.cookieVideo,
              MyAssets.cookieVideo2,
              MyAssets.cookieVideo3,
            ]),
        GridModel(
            title: AppString.hatEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hat,
            videosPath: [
              MyAssets.hatVideo,
              MyAssets.hatVideo2,
              MyAssets.hatVideo3,
            ]),
        GridModel(
            title: AppString.shoeEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.shoe,
            videosPath: [
              MyAssets.shoeVideo,
              MyAssets.shoeVideo2,
              MyAssets.shoeVideo3,
            ]),
        GridModel(
            title: AppString.moreEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.more,
            videosPath: [
              MyAssets.moreVideo,
              MyAssets.moreVideo2,
              MyAssets.moreVideo3,
            ]),
        GridModel(
            title: AppString.catEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.cat,
            videosPath: [
              MyAssets.catVideo,
              MyAssets.catVideo2,
              MyAssets.catVideo3,
            ]),
        GridModel(
            title: AppString.dogEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.dog,
            videosPath: [
              MyAssets.dogVideo,
              MyAssets.dogVideo4,
              MyAssets.dogVideo3,
            ]),
        GridModel(
            title: AppString.babyEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.baby,
            videosPath: [
              MyAssets.babyVideo,
              MyAssets.babyVideo2,
              MyAssets.babyVideo3,
            ]),
        GridModel(
            title: AppString.carEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.car,
            videosPath: [
              MyAssets.carVideo,
              MyAssets.carVideo2,
            ]),
        GridModel(
            title: AppString.bathEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.bath,
            videosPath: [
              MyAssets.bathVideo,
            ]),
        GridModel(
            title: AppString.allGoneEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.allGone,
            videosPath: [
              MyAssets.allGoneVideo,
              MyAssets.allGoneVideo2,
              MyAssets.allGoneVideo3
            ]),
        GridModel(
            title: AppString.banananEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.banana,
            videosPath: [MyAssets.bananaVideo]),
        GridModel(
            title: AppString.milkEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.milk,
            videosPath: [MyAssets.milkVideo]),
        GridModel(
            title: AppString.juiceEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.juice,
            videosPath: [MyAssets.juiceVideo]),
        GridModel(
            title: AppString.hotEsp,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.hot,
            videosPath: [MyAssets.hotVideo]),
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
            localVideosPath: null,
            id: null,
            hidetitle: false,
            imagepath: MyAssets.a,
            videosPath: [MyAssets.aVideo]),
        GridModel(
            title: AppString.b,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.b,
            videosPath: [MyAssets.bVideo]),
        GridModel(
            title: AppString.c,
            hideImage: false,
            localVideosPath: null,
            id: null,
            hidetitle: false,
            imagepath: MyAssets.c,
            videosPath: [MyAssets.cVideo]),
        GridModel(
            title: AppString.d,
            hideImage: false,
            localVideosPath: null,
            id: null,
            hidetitle: false,
            imagepath: MyAssets.d,
            videosPath: [MyAssets.dVideo]),
        GridModel(
            title: AppString.e,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.e,
            videosPath: [MyAssets.eVideo]),
        GridModel(
            title: AppString.f,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.f,
            videosPath: [MyAssets.fVideo]),
        GridModel(
            title: AppString.g,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.g,
            videosPath: [MyAssets.gVideo]),
        GridModel(
            title: AppString.h,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.h,
            videosPath: [MyAssets.hVideo]),
        GridModel(
            title: AppString.i,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.i,
            videosPath: [MyAssets.iVideo]),
        GridModel(
            title: AppString.j,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.j,
            videosPath: [MyAssets.jVideo]),
        GridModel(
            title: AppString.k,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.k,
            videosPath: [MyAssets.kVideo]),
        GridModel(
            title: AppString.l,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.l,
            videosPath: [MyAssets.lVideo]),
        GridModel(
            title: AppString.m,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.m,
            videosPath: [MyAssets.mVideo]),
        GridModel(
            title: AppString.n,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.n,
            videosPath: [MyAssets.nVideo]),
        GridModel(
            title: AppString.o,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.o,
            videosPath: [MyAssets.oVideo]),
        GridModel(
            title: AppString.p,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.p,
            videosPath: [MyAssets.pVideo]),
        GridModel(
            title: AppString.q,
            hideImage: false,
            localVideosPath: null,
            id: null,
            hidetitle: false,
            imagepath: MyAssets.q,
            videosPath: [MyAssets.qVideo]),
        GridModel(
            title: AppString.r,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.r,
            videosPath: [MyAssets.rVideo]),
        GridModel(
            title: AppString.s,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.s,
            videosPath: [MyAssets.sVideo]),
        GridModel(
            title: AppString.t,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.t,
            videosPath: [MyAssets.tVideo]),
        GridModel(
            title: AppString.u,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.u,
            videosPath: [MyAssets.uVideo]),
        GridModel(
            title: AppString.v,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.v,
            videosPath: [MyAssets.vVideo]),
        GridModel(
            title: AppString.w,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.w,
            videosPath: [MyAssets.wVideo]),
        GridModel(
            title: AppString.x,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.x,
            videosPath: [MyAssets.xVideo]),
        GridModel(
            title: AppString.y,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.y,
            videosPath: [MyAssets.yVideo]),
        GridModel(
            title: AppString.z,
            hideImage: false,
            hidetitle: false,
            localVideosPath: null,
            id: null,
            imagepath: MyAssets.z,
            videosPath: [MyAssets.zVideo]),
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
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341856302_image_picker_F6EBE71C-74D0-46C8-BA2A-442D6FF4E455-6544-0000007ED536D6C0trim.05F29A2C-52D0-4B92-B1F1-65D7D243CA6D.MOV?alt=media&token=241da210-49c8-410e-b852-52b21e7da8d6"
            ]),
        GridModel(
            title: AppString.one,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.one,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341971131_image_picker_1ECF6AD4-EA11-4729-B23D-2E53DAC74D31-6544-0000007E172E9CBFtrim.AF39084D-B960-4D50-9426-C798E50EAEE9.MOV?alt=media&token=f9d3493e-f2b3-4fd2-8ee1-c589a90a53c2"
            ]),
        GridModel(
            title: AppString.two,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.two,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341973577_image_picker_AB5F3F0D-5423-4286-8C96-B36EFD49E1EA-18895-000001E0E4F80FB5trim.FE1CB752-E199-4211-BBB6-E398D2306E67.MOV?alt=media&token=57fcf372-86d1-44cc-b125-f1116fad523a"
            ]),
        GridModel(
            title: AppString.three,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.three,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341976003_image_picker_D288F9BA-5FE0-44F9-A78E-D3933F44C208-18895-000001E0B03B5C83trim.529FAA7A-B29E-43CA-821B-A6EDCA04FFDB.MOV?alt=media&token=afbe5126-71f3-40e2-a4f0-090ddc5259ca"
            ]),
        GridModel(
            title: AppString.four,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.four,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341978444_image_picker_86449522-0FCE-44A8-BF3E-A85251BA0DE4-18895-000001E08EAF2E8Btrim.2E5D18BE-B1C8-45FA-965F-21F4E04885B1.MOV?alt=media&token=0088b93a-018a-4988-9f74-f1480064918b"
            ]),
        GridModel(
            title: AppString.five,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.five,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341981797_image_picker_C89461D0-A623-4D4F-8C9E-D44504D12104-18895-000001E1CE55618Btrim.153C3329-0510-405A-9735-8E17DC403210.MOV?alt=media&token=048a43cf-ef39-4873-8350-b8393427ae5e"
            ]),
        GridModel(
            title: AppString.six,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.six,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768341984246_image_picker_8B0A01A8-7316-4EA5-AF56-9F9746D6297D-18895-000001E0409D65C6trim.2AAAD153-C286-4546-AC4C-376F3DCB6C7A.MOV?alt=media&token=1751b1cc-2851-4ba6-8324-af87ab801476"
            ]),
        GridModel(
            title: AppString.seven,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.seven,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768342136924_image_picker_139F87AA-0C1C-4CA0-ABFD-11A4101AD03F-18895-000001DE8199FF58trim.4524FF42-3A29-4A5B-BC55-D248CDCC69F0.MOV?alt=media&token=849654c1-8834-4afd-9d04-8dce20afeba6"
            ]),
        GridModel(
            title: AppString.eight,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.eight,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768342139571_image_picker_F98CBC57-4543-4789-9E15-DD3B913040FA-18895-000001DE4B16D132trim.A234A489-01B6-41FB-A6D2-F1D53B50F87A.MOV?alt=media&token=e803274d-4707-4628-9c1e-46597c55b84a"
            ]),
        GridModel(
            title: AppString.nine,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.nine,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768342142127_image_picker_A7A99CE0-B0B6-408D-870C-981640C5FB17-18895-000001DE6A7A2FB9trim.93448FE0-616E-4429-874B-581807CEF9F3.MOV?alt=media&token=dee9eefa-1684-480b-8ea0-47d1e5ca23ae"
            ]),
        GridModel(
            title: AppString.ten,
            hideImage: false,
            hidetitle: false,
            imagepath: MyAssets.ten,
            videosPath: [
              "https://firebasestorage.googleapis.com/v0/b/wordtube2-9a7f9.firebasestorage.app/o/videos%2F1768342144586_image_picker_C9C5FF76-0106-4F78-862B-776B58AE59C9-19691-00000257110BDF40trim.8AB2BF6C-5DC1-4184-97ED-1B95177F5461.MOV?alt=media&token=272c30cb-c214-4cd8-ba9d-63f00767b6dd"
            ]),
      ]),
];
