import 'package:flutter/material.dart';
import 'package:word_toob/src/app_providers/content_provider.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/utils/common_functions.dart';
import 'package:word_toob/src/source/models/grid_model.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/game.dart';
import 'package:word_toob/src/views/widgets/main_dashboard_widgets/grids/normal.dart';

Widget gridBoard({
  required MainDashboardController value,
  required ContentProvider contentProvider,
  required double fontSize,
  required void Function(String title, int index) onTap,
}) {
  return GridView.builder(
    // shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: value.gridSizedModel.gridSizeY ?? 4,
      childAspectRatio: 1,
    ),

    itemCount: value.gridSizedModel.listData?.length,
    itemBuilder: (context, index) {
      final GridModel grid =
          value.gridSizedModel.listData?[index] ?? GridModel();
      // final findTheWrongWord =
      //     ! value.findTheWordWrongList.contains(index);

      if (value.findTheWord || value.freePlay == false) {
        // return Builder(
        //   builder: (context) => InkWell(
        //     onTap: () {
        //       if ( value.targetFindWord == grid.title) {
        //          value.setFindWordImage(true);
        //          value.setFoundSuccess(true);
        //         _onImageTap(MyAssets.correct);
        //       } else {
        //          value.setFindTheWordWrongList(index);
        //          value.setFindWordImage(true);
        //         _onImageTap(MyAssets.wrong);
        //       }
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: 5,
        //         vertical: 1,
        //       ),
        //       decoration: BoxDecoration(
        //         color: findTheWrongWord
        //             ? AppColor.cardColor
        //             : AppColor.transparent,
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(
        //           color: findTheWrongWord
        //               ? Colors.white
        //               : Colors.transparent,
        //           width: 2,
        //         ),
        //       ),
        //       child: Center(
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(
        //             vertical: context.height * 0.02,
        //             horizontal: context.width * 0.02,
        //           ),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Text(
        //                 findTheWrongWord ? grid.title ?? '?' : "",
        //                 maxLines: 2,
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .bodySmall
        //                     ?.copyWith(
        //                       color: AppColor.white,
        //                       fontWeight: FontWeight.bold,
        //                       // Adjust the font size if necessary
        //                       fontSize: fontSize,
        //                     ),
        //               ),
        //               // Add spacing between text and image
        //               SizedBox(height: context.height * 0.02),
        //               findTheWrongWord
        //                   ? Flexible(
        //                       child: grid.imagepath != null
        //                           ? grid.imagepath!
        //                                   .contains("assets")
        //                               ? Image.asset(
        //                                   grid.imagepath!,
        //                                   height: context.height *
        //                                       0.5,
        //                                   width: context.height *
        //                                       0.5,
        //                                 )
        //                               : Image.file(
        //                                   File(grid.imagepath!),
        //                                   height: context.height *
        //                                       0.5,
        //                                   width: context.height *
        //                                       0.5,
        //                                 )
        //                           : SizedBox(),
        //                     )
        //                   : SizedBox(),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // );
        return gameGridCard(
          context: context,
          value: value,
          contentProvider: contentProvider,
          grid: grid,
          index: index,
          fontSize: fontSize,
          onTap: () => onTap(grid.title ?? '', index),
        );
      } else {
        return CommonFunctions.getCheckforGridShow(
          isEditPressedYellow: value.editPressedYello,
          hideImage: grid.hideImage ?? false,
          hideTitle: grid.hidetitle ?? false,
        )
            ? basicGrid(
                value: value,
                contentProvider: contentProvider,
                grid: grid,
                index: index,
                fontSize: fontSize,
              )
            // ? Builder(
            //     builder: (context) => Stack(
            //       children: [
            //         GestureDetector(
            //           onLongPress: () =>
            //                value.hideOrShowEachGrid(
            //              contentProvider,
            //             index,
            //             hideTitle: true,
            //             hideImage: true,
            //           ),
            //           onTap: () {
            //             // value.setItemOnEditState(index,context,title: "Happy",picture: MyAssets.happy );
            //              value.setItemOnEditState(
            //               hide: grid.hidetitle ?? false,
            //               index,
            //               context,
            //               title: grid.title ?? '',
            //               picture: grid.imagepath ?? "",
            //               id:  value.gridSizedModel.id ??
            //                   -1,
            //               videoPath: grid.videosPath ?? [],
            //               gridIndex:  value.gridIndex,
            //             );

            //             //  value.setLottie();
            //              value.flutterTts
            //                 .speak(grid.title ?? "");

            //             if (! value.editPressedYello) {
            //               if (grid.videosPath?.isNotEmpty ??
            //                   false) {
            //                 var rand = Random().nextInt(
            //                     grid.videosPath?.length ?? 0 + 1);

            //                 dev.log(grid.videosPath!.length
            //                     .toString());
            //                 Navigator.pushNamed(
            //                     context, RouteStrings.videoPlayer,
            //                     arguments:
            //                         grid.videosPath?[rand]);
            //               } else {
            //                 dev.log("Error occured no item  ");
            //               }
            //             }
            //           },
            //           child: Container(
            //               margin: EdgeInsets.symmetric(
            //                   horizontal: 2, vertical: 1),
            //               decoration: BoxDecoration(
            //                 color: AppColor.cardColor,
            //                 borderRadius:
            //                     BorderRadius.circular(10),
            //                 border: Border.all(
            //                   color:
            //                        value.editPressedYello &&
            //                               (grid.videosPath
            //                                       ?.isNotEmpty ??
            //                                   false)
            //                           ? Colors.green
            //                           : Colors.white,
            //                   width: 2,
            //                 ),
            //               ),
            //               child: Center(
            //                 child: Padding(
            //                   padding: EdgeInsets.symmetric(
            //                     vertical: context.height * 0.02,
            //                     horizontal: context.width * 0.02,
            //                   ),
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.start,
            //                     children: [
            //                       Flexible(
            //                         child: Text(
            //                           grid.title ?? '?',
            //                           maxLines: 2,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .bodySmall
            //                               ?.copyWith(
            //                                 color: AppColor.white,
            //                                 // Adjust the font size if necessary
            //                                 fontWeight:
            //                                     FontWeight.bold,
            //                                 fontSize: fontSize,
            //                               ),
            //                         ),
            //                       ),
            //                       // Add spacing between text and image
            //                       SizedBox(
            //                         height: context.height * 0.02,
            //                       ),
            //                       if ( value
            //                               .settingsWordOnlyShow ==
            //                           1)
            //                         Flexible(
            //                           flex: 3,
            //                           child: grid.imagepath !=
            //                                   null
            //                               ? grid.imagepath!
            //                                       .contains(
            //                                           "assets")
            //                                   ? Image.asset(
            //                                       grid.imagepath!,
            //                                       height: context
            //                                               .height *
            //                                           0.5,
            //                                       width: context
            //                                               .height *
            //                                           0.5,
            //                                     )
            //                                   : Image.file(
            //                                       File(grid
            //                                           .imagepath!),
            //                                       height: context
            //                                               .height *
            //                                           0.5,
            //                                       width: context
            //                                               .height *
            //                                           0.5,
            //                                     )
            //                               : Container(),
            //                         )
            //                       else
            //                         Container(),
            //                     ],
            //                   ),
            //                 ),
            //               )),
            //         ),
            //         if ( value.editPressedYello &&
            //             grid.hideImage == true &&
            //             grid.hidetitle == true)
            //           Builder(
            //             builder: (context) => GestureDetector(
            //               onLongPress: () {
            //                  value.hideOrShowEachGrid(
            //                    contentProvider,
            //                   index,
            //                   hideTitle: false,
            //                   hideImage: false,
            //                 );
            //               },
            //               onTap: () {
            //                  value.setItemOnEditState(
            //                     hide: grid.hidetitle ?? false,
            //                     gridIndex:  value.gridIndex,
            //                     index,
            //                     context,
            //                     title: grid.title ?? "",
            //                     picture: grid.imagepath ?? "",
            //                     id:  value.gridSizedModel
            //                             .id ??
            //                         -1,
            //                     videoPath: grid.videosPath ?? []);
            //               },
            //               child: Container(
            //                 margin: EdgeInsets.symmetric(
            //                     horizontal: 2, vertical: 1),
            //                 decoration: BoxDecoration(
            //                   color: AppColor.lightBlue
            //                       .withOpacity(0.5),
            //                   borderRadius:
            //                       BorderRadius.circular(10),
            //                   // border: Border.all(color: Colors.white, width: 2),
            //                 ), // Light blue overlay with opacity
            //               ),
            //             ),
            //           ),
            //       ],
            //     ),
            //   )
            : Container();
      }
    },
  );
}
