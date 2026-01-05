import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:word_toob/src/views/theme/app_color.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'App Support',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SfPdfViewer.asset(
          'assets/Wt2 cheat sheet.pdf',
          enableDoubleTapZooming: true,
          enableTextSelection: true,
        ),
      ),
    );
  }
}

