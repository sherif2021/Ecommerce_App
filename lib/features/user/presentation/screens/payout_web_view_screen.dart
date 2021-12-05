import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PayoutWebViewScreen extends StatelessWidget {
  final String url;

  const PayoutWebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(url),
          method: 'GET',
          headers: {'Content-Type': 'application/json'}),
      onWebViewCreated: (controller) {},
      onLoadStart: (controller, url) {
        if (url.toString() == 'https://google.com/') {
          Get.back();
        }
      },
      onLoadStop: (controller, url) {},
    );
  }
}
