import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutWebView extends StatefulWidget {
  const AboutWebView({Key? key}) : super(key: key);

  @override
  _AboutWebViewState createState() => _AboutWebViewState();
}

class _AboutWebViewState extends State<AboutWebView> {
  final Completer<WebViewController> _vcontroller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://www.aisa.education',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webController) {
        _vcontroller.complete(webController);
      },
    );
    ;
  }
}
