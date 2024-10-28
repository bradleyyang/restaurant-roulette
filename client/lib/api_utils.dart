import 'dart:io'; // Add this import

String getBaseUrl() {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3000'; // Android emulator localhost
  } else if (Platform.isIOS) {
    return 'http://127.0.0.1:3000'; // iOS simulator localhost
  }
  return 'http://localhost:3000'; // Fallback
}