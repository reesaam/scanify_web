import 'scanify_controller.dart';
import 'utils/logger.dart';

/// Main Class of the Package
/// Using [ScanifyWebScanner] may using every feature of this Package

class ScanifyWebScanner extends StatefulWidget {
  final ScanifyController scanifyController;
  final bool showDocBorder;
  final Widget? child;
  final Color detectionBorderColor;
  final double detectionBorderStrokeWidth;
  final PaintingStyle detectionBorderPaintingStyle;
  final BorderRadius? borderRadius;

  const ScanifyWebScanner(
    this.scanifyController, {
    super.key,
    this.child,
    this.showDocBorder = false,
    this.detectionBorderColor = Colors.greenAccent,
    this.detectionBorderStrokeWidth = 2,
    this.detectionBorderPaintingStyle = PaintingStyle.stroke,
    this.borderRadius,
  });

  @override
  State<ScanifyWebScanner> createState() => _ScanifyWebScannerState();
}

class _ScanifyWebScannerState extends State<ScanifyWebScanner> {
  @override
  void initState() {
    widget.scanifyController.status.value = ScanifyStatus.initializing;
    if (!kIsWeb || !widget.scanifyController.value.isInitialized) {
      throwError();
    } else {
      widget.scanifyController.status.value = ScanifyStatus.initialized;
      widget.scanifyController.status.addListener(() {
        debugLog('Scanner Status: ${widget.scanifyController.status.value.name}');
        (widget.scanifyController.status.value.dispose ?? false) ? throwError() : null;
      });
      widget.scanifyController.rect
          .addListener(() => setState(() => debugLog('Rect: ${widget.scanifyController.rect.value}')));
      debugLog('isInitialized: ${widget.scanifyController.value.isInitialized}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.scanifyController.value.aspectRatio,
            child: ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.zero, child: CameraPreview(widget.scanifyController)),
          ),
          ScanifyDocumentBorderPainterWidget(
            rect: widget.scanifyController.rect.value,
            scanifyStatus: widget.scanifyController.status.value,
            color: widget.detectionBorderColor,
            strokeWidth: widget.detectionBorderStrokeWidth,
            paintingStyle: widget.detectionBorderPaintingStyle,
          ),
          if (widget.child != null) widget.child!,
        ],
      );

  @override
  void dispose() async {
    widget.scanifyController.status.value = ScanifyStatus.disposing;
    await widget.scanifyController.pausePreview();
    await widget.scanifyController.dispose();
    widget.scanifyController.status.value = ScanifyStatus.closed;
    super.dispose();
  }

  void throwError({String? message}) {
    widget.scanifyController.status.value = ScanifyStatus.error;
    throw Exception(message ?? PackageStrings.throwError);
  }
}
