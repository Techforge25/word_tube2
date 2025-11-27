import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(
    String filePath,
    String destination, {
    required Function(double) onProgress,
    Future<void>? cancelToken,
  }) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        if (kDebugMode) {
          print('File not found at path: $filePath');
        }
        return null;
      }

      final ref = _storage.ref(destination);

      // Use SettableMetadata to optimize upload settings
      final metadata = SettableMetadata(
        contentType: filePath.toLowerCase().endsWith('.mp4') ||
                filePath.toLowerCase().endsWith('.mov')
            ? 'video/mp4'
            : 'image/jpeg',
        cacheControl: 'max-age=31536000', // 1 year cache
      );

      // Use putFile with metadata for better performance
      final uploadTask = ref.putFile(file, metadata);

      final completer = Completer<String?>();
      StreamSubscription<TaskSnapshot>? subscription;
      bool isCancelled = false;

      // Cancel token handling
      cancelToken?.then((_) {
        if (!completer.isCompleted && !isCancelled) {
          isCancelled = true;
          subscription?.cancel();
          uploadTask.cancel();
          completer.complete(null);
        }
      });

      // Progress tracking with error handling
      subscription = uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          if (isCancelled || completer.isCompleted) return;

          try {
            final double progress = snapshot.totalBytes > 0
                ? snapshot.bytesTransferred / snapshot.totalBytes
                : 0.0;

            // Only update progress if not cancelled
            if (!isCancelled) {
              onProgress(progress);
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error updating progress: $e');
            }
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Upload stream error: $error');
          }
          if (!completer.isCompleted) {
            subscription?.cancel();
            completer.complete(null);
          }
        },
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Check if cancelled before getting download URL
      if (isCancelled || completer.isCompleted) {
        await subscription.cancel();
        return null;
      }

      final downloadUrl = await snapshot.ref.getDownloadURL();
      await subscription.cancel();

      if (!completer.isCompleted) {
        completer.complete(downloadUrl);
      }
      return completer.future;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase error: ${e.code} - ${e.message}');
      }
      // Handle specific Firebase errors
      if (e.code == 'canceled') {
        if (kDebugMode) {
          print('Upload was cancelled by user');
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file to Firebase Storage: $e');
      }
      return null;
    }
  }
}
