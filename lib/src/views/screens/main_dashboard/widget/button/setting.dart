import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';
import 'package:word_toob/src/common/app_constants/app_keys.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/views/widgets/custom_menu_widget.dart';
import 'package:word_toob/src/views/widgets/voices.dart';

class SettingButton extends StatefulWidget {
  final double fontSize;
  final MenuController gameMenuController;
  final double gap;
  final MainDashboardController value;

  const SettingButton({
    super.key,
    required this.fontSize,
    required this.gap,
    required this.value,
    required this.gameMenuController,
  });

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return CustomMenuAnchor(
      menuController: menuController,
      menuItems: [
        CustomMenuItemButton(
          child: Container(
            width: context.width * 0.35,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: widget.fontSize + 5,
                          fontWeight: FontWeight.w800,
                          color: AppColor.appPrimaryColor,
                        ),
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Gap(25),
                      // Text(
                      //   "Tiles",
                      //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //         fontSize: widget.fontSize + 4,
                      //         color: AppColor.appPrimaryColor.withOpacity(0.5),
                      //       ),
                      // ),
                      Gap(widget.gap),

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              widget.value.wordsOnlyShowSettings(1);
                              menuController.close();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Symbols & Word",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: widget.fontSize + 4,
                                          color: AppColor.appPrimaryColor,
                                        ),
                                  ),
                                ),
                                widget.value.settingsWordOnlyShow == 1
                                    ? const Icon(
                                        Icons.check,
                                        color: AppColor.green,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          Gap(widget.gap),
                          InkWell(
                            onTap: () {
                              widget.value.wordsOnlyShowSettings(2);
                              menuController.close();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Word Only",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: widget.fontSize + 4,
                                          color: AppColor.appPrimaryColor,
                                        ),
                                  ),
                                ),
                                widget.value.settingsWordOnlyShow == 2
                                    ? const Icon(
                                        Icons.check,
                                        color: AppColor.green,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(widget.gap),

                      //
                      // Text("SPEECH OUTPUT",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //     fontSize: fontSize+5,
                      //     color:AppColor.appPrimaryColor.withOpacity(0.5)
                      // )),
                      // Gap(gap),
                      //
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("Use Speech",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Switch(
                      //             activeColor: AppColor.white,
                      //               activeTrackColor: AppColor.green,
                      //               value: value.useSpeech, onChanged: (valueNew){
                      //               value.useSpeechFunction();
                      //
                      //           })
                      //         ],
                      //       ),
                      //       Gap(10),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //
                      //         children: [
                      //           Text("Voice",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )),
                      //           Text("English (United States)",
                      //               maxLines: 2,
                      //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+5,
                      //
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //
                      //
                      //         ],
                      //       ),
                      //
                      //
                      //
                      //
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                      // Gap(gap),
                      //
                      // Text("SPEECH RECOGNITION",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //     fontSize: fontSize+5,
                      //     color:AppColor.appPrimaryColor.withOpacity(0.5)
                      // )),
                      // Gap(gap),
                      //
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("English ",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Icon(Icons.check,color: AppColor.green,)
                      //         ],
                      //       ),
                      //       Gap(gap),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //
                      //         children: [
                      //           Text("Spanish",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: fontSize+10,
                      //               color:AppColor.appPrimaryColor
                      //           )) ,
                      //           Icon(Icons.check,color: AppColor.green,)
                      //
                      //         ],
                      //       ),
                      //
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                      // Gap(gap),

                      // Text("GAME OPTIONS",
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodyMedium
                      //         ?.copyWith(
                      //             fontSize: widget.fontSize + 8,
                      //             color: AppColor.appPrimaryColor
                      //                 .withOpacity(0.5))),
                      // Gap(widget.gap),

                      // GestureDetector(
                      //   onTap: () {
                      //     menuController.close();
                      //     widget.gameMenuController.open();
                      //   },
                      //   child: Text("Find The Word",
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodyMedium
                      //           ?.copyWith(
                      //               fontSize: widget.fontSize + 10,
                      //               color: AppColor.appPrimaryColor
                      //                   .withOpacity(0.5))),
                      // ),
                      InkWell(
                        onTap: () async {
                          menuController.close();
                          await voicesPopup(
                            context,
                            voices: widget.value.ttfVoices,
                            currentVoice: widget.value.currentVoice,
                            onVoicesTap: (v) =>
                                widget.value.onVoiceTap(v, context),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            "Change Voice",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: widget.fontSize + 4,
                                  color:
                                      AppColor.appPrimaryColor.withOpacity(0.5),
                                ),
                          ),
                        ),
                      ),
                      Gap(widget.gap),
                      InkWell(
                        onTap: () async {
                          menuController.close();
                          final box = context.findRenderObject() as RenderBox?;
                          await Share.share(
                            'Welcome to Word Toob! 📚✨\nWhether you’re a beginner or an expert, Word Toob makes learning languages fun and addictive! 🌍🎉 \nDownload now and join the adventure: ${AppKeys.appStore}\nFor more info visit: http://wordtoob.com/index.html',
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            "Share",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: widget.fontSize + 4,
                                  color:
                                      AppColor.appPrimaryColor.withOpacity(0.5),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
      titleWidget: Text(
        "Settings",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize,
            ),
      ),
    );
  }
}