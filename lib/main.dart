import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(
    MaterialApp(
        title: 'pro_webview',
        home: AnimatedSplashScreen(
            duration: 2000,
            splash: 'assets/images/prosoft_logo.png',
            nextScreen: WebViewExample(),
            splashTransition: SplashTransition.sizeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.white),
        )
);

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://wms.ctr.co.kr/mobile/login.html'));
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          var future = controller.canGoBack();
          future.then((canGoBack) => {
            if(canGoBack){
              controller.goBack()
            }else{
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('앱 종료'),
                    content: Text('앱을 종료하시겠습니까?'),
                    actions: [
                      TextButton(onPressed: (){
                        SystemNavigator.pop();
                      }, child: Text("예")),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("아니요"))
                    ],
                  ))
            }
          });
          return Future.value(false);
        },
        child: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
// #enddocregion webview_widget
}