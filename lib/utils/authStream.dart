import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class AuthStream {
  StreamController _controller = StreamController.broadcast();
  Stream get stream => _controller.stream;
  StreamSubscription? _intentDataStreamSubscription;
  AuthStream() {
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == "tyckaapp://loggedIn") {
        _controller.sink.add(value);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  void dispose() {
    _controller.close();
    _intentDataStreamSubscription?.cancel();
  }
}
