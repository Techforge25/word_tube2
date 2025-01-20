import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab bar
            TabBar(
              tabs: [
                Tab(text: 'Using the app'),
                Tab(text: 'Who we are'),
                Tab(text: 'Credits'),
              ],
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
            ),
            SizedBox(height: 16),

            // Tab bar view
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab Content - "Using the app"
                  UsingAppTab(),

                  // Second Tab - "Who we are"
                  Center(
                    child: Text('Who we are content goes here.'),
                  ),

                  // Third Tab - "Credits"
                  Center(
                    child: Text('Credits content goes here.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted "Using the app" content into its own widget
class UsingAppTab extends StatelessWidget {
  const UsingAppTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wider Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Support',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Wordtoob is designed to make learning words fun and engaging. People of all ages and intellectual levels enjoy videos. With Wordtoob they can now play an active role in learning while doing what they love.\n\n"
                    "John Halloran M.S. CCC-SLP\n\n"
                    "Learning language requires combined information from the senses, whether just beginning to learn one's native language or learning a second language. Wordtoob makes this fun and easy by pairing words with illustrative videos. The learner not only benefits from playing Word Toob but also through engaging in creating personalized videos.\n\n"
                    "With WordToob, you have the ability of teaching through video modeling which is a proven method for teaching targeted skills particularly for individuals with autism. Personalized videos can be easily created with the iPad camera and attached to words within the app to maintain novelty and increase motivation.\n\n"
                    "The ability to customize boards gives Word Toob the ability to address many different skills limited only by your imagination. Some uses include:\n"
                    "• Learning new words\n"
                    "• Recognizing words you hear\n"
                    "• Improving articulation\n"
                    "• Learning social skills\n"
                    "• Recognizing emotions\n"
                    "• Visual schedules\n"
                    "• Show and tell\n"
                    "• Literacy",
                    maxLines: context.height.toInt(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // Narrow Section
          Expanded(
            flex: 1,
            child: Container(
              height: context.height,
              color: Colors.blue.withOpacity(0.4),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                      maxLines: 30,
                      style: TextStyle(color: Colors.black),
                      "Skills\n\n"
                      "Laure what word man\n"
                      "Recognize words you hear\n"
                      "Say words comety\n"
                      "Lem social skills\n"
                      "Recognize embos\n"
                      "Visual Schedules\n"
                      "Show and Tell\n"
                      "Literacy\n"
                      "App Support\n"
                      "App Map"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
