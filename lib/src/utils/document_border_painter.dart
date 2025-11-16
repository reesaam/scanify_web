import '../scanify_controller.dart';
import 'logger.dart';

/// This is the Border of the Document in Camera Screen
/// You may observe the real time document detection in the camera screen

class ScanifyDocumentBorderPainterWidget extends StatefulWidget {
  final Rect rect;
  final ScanifyStatus scanifyStatus;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;
  const ScanifyDocumentBorderPainterWidget({
    super.key,
    required this.rect,
    required this.scanifyStatus,
    required this.color,
    required this.strokeWidth,
    required this.paintingStyle,
  });

  @override
  State<ScanifyDocumentBorderPainterWidget> createState() => _ScanifyDocumentBorderPainterWidgetState();
}

class _ScanifyDocumentBorderPainterWidgetState extends State<ScanifyDocumentBorderPainterWidget> {
  @override
  Widget build(BuildContext context) => _isDrawing(rect: widget.rect, scanifyStatus: widget.scanifyStatus)
      ? CustomPaint(
          painter: ScanifyDocumentBorderPainter(
            widget.rect,
            widget.color,
            widget.strokeWidth,
            widget.paintingStyle,
          ),
          child: Container(),
        )
      : _notAvailable;
}

class ScanifyDocumentBorderPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;
  const ScanifyDocumentBorderPainter(
    this.rect,
    this.color,
    this.strokeWidth,
    this.paintingStyle,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    Path path = Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

bool _isDrawing({required Rect rect, required ScanifyStatus scanifyStatus}) {
  final result = PackageDefaults.drawDocumentBorder && scanifyStatus == ScanifyStatus.scanning && rect != Rect.zero;
  releaseLog('ScanifyDocumentBorderPainter IsDrawing: $result');
  return result;
}

Widget get _notAvailable => const SizedBox.shrink();
