import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    dotenv.env['CLOUD_NAME']!,
    'word_toob',
    cache: false,
  );
}
