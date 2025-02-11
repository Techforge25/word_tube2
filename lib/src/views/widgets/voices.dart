import 'package:flutter/material.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'dart:developer' as dev;

Future<dynamic> voicesPopup(
  BuildContext context, {
  required List<Map> voices,
  Map? currentVoice,
  void Function(Map selected)? onVoicesTap,
}) async {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;
  double fontSize = 20;

  dev.log(currentVoice.toString());

  await AppUtility.appDialog(
    context,
    child: Container(
      height: height * 0.5,
      width: width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Available Voices',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize + 5,
                ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Names',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                  ),
            ),
            trailing: Text(
              'Genders',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                  ),
            ),
          ),
          Divider(),
          Flexible(
            child: ListView.separated(
              itemCount: voices.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) => ListTile(
                onTap: onVoicesTap == null
                    ? () => dev.log(
                          'Selected Voice: ${voices[index]['name']}',
                          name: 'onVoiceTap',
                        )
                    : () => onVoicesTap(voices[index]),
                dense: true,
                // leading: Visibility(
                //   visible: currentVoice != null && voices[index]['name'] == currentVoice['name'],
                //   child: Icon(
                //     Icons.check_circle_outline_rounded,
                //     size: 35,
                //     color: AppColor.greenLight,
                //   ),
                // ),
                title: Text(
                  '${voices[index]['name']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: currentVoice != null &&
                                voices[index]['name'] == currentVoice['name']
                            ? AppColor.cardColor
                            : AppColor.grey,
                        fontWeight: currentVoice != null &&
                                voices[index]['name'] == currentVoice['name']
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: fontSize,
                      ),
                ),
                trailing: Text(
                  '${voices[index]['gender'] == 'unspecified' ? 'ROBOT' : voices[index]['gender']}'
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: currentVoice != null &&
                                voices[index]['name'] == currentVoice['name']
                            ? AppColor.cardColor
                            : AppColor.grey,
                        fontWeight: currentVoice != null &&
                                voices[index]['name'] == currentVoice['name']
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: fontSize,
                      ),
                ),
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
          )
        ],
      ),
    ),
  );
}
