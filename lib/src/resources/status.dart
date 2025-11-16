enum ScanifyStatus {
  initializing,
  cameraInitializing,
  initialized,
  scanning,
  scanned(),
  disposing(dispose: true),
  closed(dispose: true),
  unknown,
  error(dispose: true);

  final bool? dispose;
  const ScanifyStatus({this.dispose});
}