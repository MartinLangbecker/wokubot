import 'package:flutter/foundation.dart';

class ConnectionModel with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void setConnectionState(bool state) {
    _isConnected = state;
    notifyListeners();
  }

  void toggleConnectionState() {
    _isConnected = !_isConnected;
    notifyListeners();
  }
}
