import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(
    String filePath,
    String destination, {
    required Function(double) onProgress,
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

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
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
