import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'document_scanner.dart';
import 'extensions/extensions.dart';
import 'models/detection_arguments.dart';
import 'models/detection_model.dart';
import 'models/scanify_response.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

//Exports
export 'package:flutter/material.dart';
export 'package:camera/camera.dart';
export 'package:flutter/foundation.dart';
export 'resources/resources.dart';
export 'utils/document_border_painter.dart';
export 'extensions/extensions.dart';

class ScanifyController extends CameraController {
  final DetectionArguments? detectionArguments;
  ValueNotifier<ScanifyStatus> status = ValueNotifier(ScanifyStatus.closed);
  ValueNotifier<Rect> rect = ValueNotifier(Rect.zero);

  ScanifyController({
    required this.description,
    this.resolutionPreset = ResolutionPreset.low,
    this.detectionArguments,
  }) : super(description, resolutionPreset);

  @override
  CameraDescription description;

  @override
  ResolutionPreset resolutionPreset;

  @override
  Future<void> initialize() async {
    status.value = ScanifyStatus.cameraInitializing;
    return super.initialize();
  }

  Future<ScanifyResponse> startAutoScan() async {
    releaseLog('AutoScan Started ...');
    status.value = ScanifyStatus.scanning;
    DetectionModel? detectionResponse;
    DetectionArguments arguments = detectionArguments ?? DetectionArguments();
    await Future.doWhile(
      () async {
        await Future.delayed(Duration(seconds: arguments.streamCaptureDelay));
        final capturedImage = await takePicture();
        final convertedImage = await capturedImage.toImageFormat;
        releaseLog('Picture Taken ${DateTime.now().toLocal()}');
        if (convertedImage != null) {
          /// ANALYZE
          detectionResponse = analyze(
            detectionArguments: arguments,
            image: convertedImage,
            file: capturedImage,
          );
          rect.value = detectionResponse?.rect ?? Rect.zero;
          if (detectionResponse?.isFound ?? false) {
            releaseLog('Document Found');
            releaseLog('Changing Scanner Status');

            final imageData = await capturedImage.readAsBytes();
            final imageFile = XFile.fromData(imageData);
            Uint8List? croppedData = await imageFile.cropToUintListImage(detectionResponse!.rect);

            debugLog('response name: ${detectionResponse?.name}');
            debugLog('response path: ${detectionResponse?.path}');
            debugLog('response length: ${await detectionResponse?.originalImageFile?.length()}');
            detectionResponse = detectionResponse?.copyWith(
              name: imageFile.name,
              path: imageFile.path,
              originalImageFile: imageFile,
              originalImageData: imageData,
              croppedData: croppedData,
            );
            status.value = ScanifyStatus.scanned;
          }
        }

        releaseLog('status: ${status.value}');
        return status.value == ScanifyStatus.scanning;
      },
    );
    final ScanifyResponse scannerResponse = ScanifyResponse(
      path: detectionResponse?.path,
      imageFile: detectionResponse?.originalImageFile,
      imageData: detectionResponse?.originalImageData,
      rect: detectionResponse?.rect,
      croppedData: detectionResponse?.croppedData,
      analyzeData: detectionResponse?.analyzeData,
    );
    return scannerResponse;
  }

  void stopAutoScan() {
    status.value = ScanifyStatus.closed;
  }
}
