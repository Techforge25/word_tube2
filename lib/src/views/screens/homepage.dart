// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:word_toob/common/app_constants/app_strings.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     initTTS();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildUI(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//         },
//         child: const Icon(
//           Icons.speaker_phone,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUI() {
//     return SafeArea(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _speakerSelector(),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               style: const TextStyle(
//                 fontWeight: FontWeight.w300,
//                 fontSize: 20,
//                 color: Colors.black,
//               ),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: AppString.TTS_INPUT.substring(0, _currentWordStart),
//                 ),
//                 if (_currentWordStart != null)
//                   TextSpan(
//                     text: AppString.TTS_INPUT.substring(
//                         _currentWordStart!, _currentWordEnd),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       backgroundColor: Colors.purpleAccent,
//                     ),
//                   ),
//                 if (_currentWordEnd != null)
//                   TextSpan(
//                     text: AppString.TTS_INPUT.substring(_currentWordEnd!),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _speakerSelector() {
//     return DropdownButton(
//       value: _currentVoice,
//       items: _voices
//           .map(
//             (_voice) => DropdownMenuItem(
//           value: _voice,
//           child: Text(
//             _voice["name"],
//           ),
//         ),
//       )
//           .toList(),
//       onChanged: (value) {},
//     );
//   }
// }
