import '../../scanify_web.dart';

class ScanifyResponse {
  const ScanifyResponse({
    this.path,
    this.imageFile,
    this.imageData,
    this.croppedData,
    this.analyzeData,
    this.rect,
  });

  final String? path;
  final XFile? imageFile;
  final Uint8List? imageData;
  final Uint8List? croppedData;
  final Uint8List? analyzeData;
  final Rect? rect;
}