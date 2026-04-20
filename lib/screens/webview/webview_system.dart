import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController _webViewController;
  String url = "https://enyecontrols.com/enyecontrols_systems/index.php";
  final GlobalKey webViewKey = GlobalKey();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Enyecontrols System" /*Image.asset('assets/logo/enyecontrols.png', height: 20,*/),  // Adjust the height to fit your design
       /* leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (await _webViewController.canGoBack()) {
              _webViewController.goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),*/
      ),
      body: Stack(
        children:[ InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            ),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              isLoading = true;
            });
          },
          onLoadStop: (controller, url) async {
            setState(() {
              isLoading = false;
            });
            String cookies = await _webViewController.evaluateJavascript(
                source: """
                  document.cookie;
                """);
            print("Cookies: $cookies");
          },
          onLoadError: (controller, url, code, message) {
            setState(() {
              isLoading = false;
            });

          },
        ),
      isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(),
      ],
      ),
    );
  }
}

/*void main() {
  runApp(MaterialApp(
    home: WebViewPage(),
  ));
}*/
