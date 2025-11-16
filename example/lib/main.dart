import 'package:scanify_web/scanify_web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScanifyApp());
}

class ScanifyApp extends StatelessWidget {
  const ScanifyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Scanify Web Document Scanner",
        home: ScanifyPage(),
      );
}

class ScanifyPage extends StatefulWidget {
  const ScanifyPage({super.key});

  @override
  State<ScanifyPage> createState() => _ScanifyPageState();
}

class _ScanifyPageState extends State<ScanifyPage> {
  /// [Variables] to control and modify settings and functionalities
  ScanifyController? scanifyController;
  ScanifyStatus scanifyStatus = ScanifyStatus.closed;
  ScannerResponse scanifyResponse = ScannerResponse();

  @override
  void initState() {
    /// [ScanifyController] should be Initialized Before showing it's widget
    /// [ScanifyController] will initialize the Camera
    ///     Initialization procedure includes:
    ///       - Getting Permissions for Camera
    ///       - Variables Assignments (Status, Response, Detection Model, DetectionArguments, ...)
    ///       - Setting Controllers

    _controllerInitialization();

    /// [startAutoScan] of [ScanifyController] can be either here to start by page initialization
    /// OR
    /// Use it by an action such as Tapping on a Button

    super.initState();
  }

  void _controllerInitialization() async {
    scanifyStatus = ScanifyStatus.initializing;
    final List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final CameraDescription selectedCamera = cameras.first;
      scanifyController = ScanifyController(description: selectedCamera);
      if (scanifyController != null) {
        await scanifyController?.initialize();
      } else {
        throw Exception(PackageStrings.throwErrorControllerInitialization);
      }
    } else {
      throw Exception(PackageStrings.throwErrorCameraAvailability);
    }
  }

  /// [AutoScan] can be triggered in many ways
  /// such as page initialization, which trigger [AutoScan] in page start
  /// Or by Tapping on a [Button]
  void startAutoScan() async {
    scanifyStatus = ScanifyStatus.scanning;
    scanifyResponse = await scanifyController!.startAutoScan();
  }

  void stopAutoScan() {
    scanifyStatus = ScanifyStatus.closed;
  }

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(PackageStrings.packageName),
        ScanifyWebScanner(scanifyController!),
        Image.memory(scanifyResponse.imageData!, fit: BoxFit.contain),
        Image.memory(scanifyResponse.croppedData!, fit: BoxFit.contain),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => scanifyController!.startAutoScan(), child: Text('Start AutoScan')),
            ElevatedButton(
                onPressed: () => scanifyController!.stopAutoScan(), child: Text('Stop AutoScan')),
          ],
        )
      ]);
}
