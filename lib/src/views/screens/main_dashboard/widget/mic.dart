import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:developer' as dev;

class VoiceInput extends StatefulWidget {
  const VoiceInput({super.key});

  @override
  VoiceInputState createState() => VoiceInputState();
}

class VoiceInputState extends State<VoiceInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  double _soundLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => dev.log('Status: $status'),
      onError: (error) => dev.log('Error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onSoundLevelChange: (level) {
          setState(() => _soundLevel = level);
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Input with Sound Level')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 50,
              ),
              onPressed: _isListening ? _stopListening : _startListening,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                10,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: (_soundLevel / 10 * (index + 1)).clamp(5.0, 50.0),
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
