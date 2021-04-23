import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final String userId;

  const CallScreen({this.userId, this.channelId});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    endCall();
    permision();
    super.initState();
  }

  void permision() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  void endCall() async {
    await CallService().endCall(userId: this.widget.userId);
  }

  InAppWebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop()),
            title: Text("InAppWebView")),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          "https://appr.tc/r/${this.widget.channelId}")),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                  },
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  }),
            ),
          ),
        ])));
  }
}
