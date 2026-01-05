import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';
import 'package:word_toob/src/common/utils/navigation_animation.dart';
import 'package:word_toob/src/views/screens/splash_screen.dart';
import 'package:word_toob/src/views/screens/main_dashboard/main_dashboard.dart'
    hide SharedBoardPreviewScreen;
import 'package:word_toob/src/views/screens/video/video_player.dart';
import 'package:word_toob/src/views/screens/help/help_screen.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'dart:convert';
import 'dart:io';
import 'package:word_toob/src/source/models/grid_size_model.dart';
import 'package:word_toob/src/services/firebase_storage_service.dart';
import 'package:gap/gap.dart';
import 'package:word_toob/src/views/theme/app_color.dart';
import 'package:word_toob/src/common/utils/app_utility.dart';

import 'dart:developer' as dev;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("Route -> ${settings.name}");

    if (settings.name != null && settings.name!.endsWith('.wtdata')) {
      print('From Logs Router ${settings.name}');
      return MaterialPageRoute(
        builder: (_) => BoardLoaderScreen(filePath: settings.name!),
      );
    } else {
      final args = settings.arguments;
      switch (settings.name) {
        case RouteStrings
              .dispatcher: // Aapko yeh string constants mein add karni hogi
          return MaterialPageRoute(
              builder: (_) => SplashScreen(
                    filePath: settings.name,
                  ));
        case RouteStrings.mainDashboardView:
          return MaterialPageRoute(
              // builder: (_) => const ResponsiveWrap(child: MainDashboard()));
              builder: (_) => const MainDashboard());
        case RouteStrings.videoPlayer:
          final Map<String, dynamic> argsMap = args as Map<String, dynamic>;
          return SwipeLeftAnimationRoute(
              widget:
                  // ResponsiveWrap(child: VideoPlayerView(url: args as String)));
                  VideoPlayerView(
            url: argsMap['url'] as String,
            localUrl: argsMap['localUrl'] as String?,
          ));
        case RouteStrings.helpScreen:
          return MaterialPageRoute(
            builder: (_) => const HelpScreen(),
          );
        default:
          return _errorRoute();
      }
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class DownloadProgress {
  final int totalFiles;
  final int downloadedFiles;
  final String currentFileName;
  final double currentFileProgress;

  DownloadProgress({
    this.totalFiles = 0,
    this.downloadedFiles = 0,
    this.currentFileName = '',
    this.currentFileProgress = 0.0,
  });

  DownloadProgress copyWith({
    int? totalFiles,
    int? downloadedFiles,
    String? currentFileName,
    double? currentFileProgress,
  }) {
    return DownloadProgress(
      totalFiles: totalFiles ?? this.totalFiles,
      downloadedFiles: downloadedFiles ?? this.downloadedFiles,
      currentFileName: currentFileName ?? this.currentFileName,
      currentFileProgress: currentFileProgress ?? this.currentFileProgress,
    );
  }
}

class BoardLoaderScreen extends StatefulWidget {
  final String filePath;

  const BoardLoaderScreen({super.key, required this.filePath});

  @override
  State<BoardLoaderScreen> createState() => _BoardLoaderScreenState();
}

class _BoardLoaderScreenState extends State<BoardLoaderScreen> {
  late Future<GridSizeModel> _loadBoardFuture;
  final ValueNotifier<DownloadProgress> _progressNotifier =
      ValueNotifier(DownloadProgress());
  bool _isCancelled = false;

  void _cancelDownload() {
    setState(() {
      _isCancelled = true;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _loadBoardFuture = _loadBoard();
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  Future<GridSizeModel> _loadBoard() async {
    try {
      dev.log("BoardLoader: Loading board from ${widget.filePath}");
      final file = File(widget.filePath);
      final jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        throw Exception("Shared file is empty.");
      }
      final jsonData = jsonDecode(jsonString);
      final board = GridSizeModel.fromJson(jsonData);

      // Calculate total files to download
      int totalFiles = 0;
      for (var item in board.listData ?? []) {
        if (item.imagepath != null &&
            item.imagepath!.isNotEmpty &&
            item.imagepath!.startsWith('http')) {
          totalFiles++;
        }
        if (item.videosPath != null) {
          for (var videoUrl in item.videosPath!) {
            if (videoUrl.isNotEmpty && videoUrl.startsWith('http')) {
              totalFiles++;
            }
          }
        }
      }

      // If there are files to download, check internet connection
      if (totalFiles > 0) {
        final hasInternet = await checkInternetConnection();
        if (!hasInternet) {
          throw Exception(
              "Internet connection required to download shared board files. Please check your internet connection and try again.");
        }
      }

      _progressNotifier.value =
          _progressNotifier.value.copyWith(totalFiles: totalFiles);

      final firebaseService = FirebaseStorageService();
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      int downloadedFiles = 0;

      for (var item in board.listData ?? []) {
        if (_isCancelled) {
          throw Exception("Download cancelled by user");
        }

        if (item.imagepath != null &&
            item.imagepath!.isNotEmpty &&
            item.imagepath!.startsWith('http')) {
          final fileName =
              '${DateTime.now().millisecondsSinceEpoch}_${item.imagepath!.split('/').last.split('?').first}';
          _progressNotifier.value = _progressNotifier.value.copyWith(
            currentFileName: fileName,
            currentFileProgress: 0.0,
          );
          try {
            if (_isCancelled) {
              throw Exception("Download cancelled by user");
            }
            final localImagePath = '${appDocumentsDir.path}/$fileName';
            final downloadedFile = await firebaseService.downloadFile(
              item.imagepath!,
              localImagePath,
              onProgress: (progress) {
                if (!_isCancelled) {
                  _progressNotifier.value = _progressNotifier.value
                      .copyWith(currentFileProgress: progress);
                }
              },
            );

            if (_isCancelled) {
              throw Exception("Download cancelled by user");
            }

            if (downloadedFile != null && await downloadedFile.exists()) {
              item.imagepath = downloadedFile.path;
              downloadedFiles++;
              _progressNotifier.value = _progressNotifier.value
                  .copyWith(downloadedFiles: downloadedFiles);
            }
          } catch (e) {
            if (_isCancelled) {
              throw Exception("Download cancelled by user");
            }
            dev.log('Error downloading image: $e');
          }
        }

        if (item.videosPath != null) {
          final updatedVideos = <String>[];
          final updatedLocalVideos = <String>[];
          for (var videoUrl in item.videosPath!) {
            if (_isCancelled) {
              throw Exception("Download cancelled by user");
            }

            if (videoUrl.isNotEmpty && videoUrl.startsWith('http')) {
              final fileName =
                  '${DateTime.now().millisecondsSinceEpoch}_${videoUrl.split('/').last.split('?').first}';
              _progressNotifier.value = _progressNotifier.value.copyWith(
                currentFileName: fileName,
                currentFileProgress: 0.0,
              );
              try {
                if (_isCancelled) {
                  throw Exception("Download cancelled by user");
                }
                final localVideoPath = '${appDocumentsDir.path}/$fileName';
                final downloadedFile = await firebaseService.downloadFile(
                  videoUrl,
                  localVideoPath,
                  onProgress: (progress) {
                    if (!_isCancelled) {
                      _progressNotifier.value = _progressNotifier.value
                          .copyWith(currentFileProgress: progress);
                    }
                  },
                );

                if (_isCancelled) {
                  throw Exception("Download cancelled by user");
                }

                if (downloadedFile != null && await downloadedFile.exists()) {
                  updatedVideos.add(downloadedFile.path);
                  updatedLocalVideos.add(downloadedFile.path);
                  downloadedFiles++;
                  _progressNotifier.value = _progressNotifier.value
                      .copyWith(downloadedFiles: downloadedFiles);
                } else {
                  updatedVideos.add(videoUrl);
                }
              } catch (e) {
                if (_isCancelled) {
                  throw Exception("Download cancelled by user");
                }
                dev.log('Error downloading video: $e');
                updatedVideos.add(videoUrl);
              }
            } else {
              updatedVideos.add(videoUrl);
              if (item.localVideosPath != null &&
                  item.localVideosPath!.contains(videoUrl)) {
                updatedLocalVideos.add(videoUrl);
              }
            }
          }
          item.videosPath = updatedVideos;
          item.localVideosPath =
              updatedLocalVideos.isNotEmpty ? updatedLocalVideos : null;
        }
      }
      return board;
    } catch (e) {
      dev.log("BoardLoader: Failed to load board.", error: e);
      throw Exception("Could not load the board. The file might be corrupted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GridSizeModel>(
      future: _loadBoardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: ValueListenableBuilder<DownloadProgress>(
                valueListenable: _progressNotifier,
                builder: (context, progress, child) {
                  final overallProgress = progress.totalFiles > 0
                      ? progress.downloadedFiles / progress.totalFiles
                      : 0.0;
                  final statusMessage = progress.totalFiles > 0
                      ? '${progress.downloadedFiles} of ${progress.totalFiles} files'
                      : 'Preparing to download...';

                  return PopScope(
                    canPop: false,
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColor.lightSecondaryColor
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    overallProgress > 0
                                        ? Icons.cloud_download
                                        : Icons.file_download,
                                    size: 32,
                                    color: AppColor.lightSecondaryColor,
                                  ),
                                ),
                                const Gap(16),
                                Text(
                                  overallProgress > 0
                                      ? 'Downloading Content'
                                      : 'Receiving Shared Board',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColor.textBodyColor,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(8),
                                Text(
                                  overallProgress > 0
                                      ? 'Downloading content from cloud...\nPlease wait while we process your files'
                                      : statusMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(16),
                                if (overallProgress > 0) ...[
                                  Container(
                                    width: double.infinity,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[200],
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          overallProgress.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.lightSecondaryColor,
                                              AppColor.lightSecondaryColor
                                                  .withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(overallProgress * 100).toStringAsFixed(0)}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color:
                                                  AppColor.lightSecondaryColor,
                                            ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        'Complete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.lightSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                                const Gap(16),
                                // Cancel Button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _cancelDownload();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      side: BorderSide(
                                        color: Colors.grey[400]!,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close button (X) at top-right
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _cancelDownload();
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          // If cancelled, just navigate back
          if (snapshot.error.toString().contains("cancelled")) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
            return Scaffold(
              body: Container(),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Error loading board: ${snapshot.error}"),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return SharedBoardPreviewScreen(board: snapshot.data!);
        }

        return const Scaffold(
          body: Center(child: Text("An unknown error occurred.")),
        );
      },
    );
  }
}
