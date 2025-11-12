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
      final uploadTask = ref.putFile(file);

      final completer = Completer<String?>();

      final sub = uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final double progress = snapshot.totalBytes > 0
            ? snapshot.bytesTransferred / snapshot.totalBytes
            : 0.0;
        onProgress(progress);
      });

      cancelToken?.then((_) async {
        if (!completer.isCompleted) {
          await sub.cancel();
          await uploadTask.cancel();
          completer.complete(null);
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (!completer.isCompleted) {
        await sub.cancel();
        completer.complete(downloadUrl);
      }
      return completer.future;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase error: ${e.code} - ${e.message}');
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
