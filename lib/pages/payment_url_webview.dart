import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../view_models/payment_view_model.dart';

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() =>
      _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  final PaymentViewModel _paymentViewModel = Get.put(
    PaymentViewModel(),
  );

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams
    params;
    params =
        const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                final uri = Uri.parse(url);
                final code = uri.queryParameters['code'];
                final id = uri.queryParameters['id'];
                final orderCode =
                    uri.queryParameters['orderCode'];
                if (code == '00' && id != null) {
                  _paymentViewModel.handlePaymentResponse(
                    id,
                    orderCode!,
                  );
                  _paymentViewModel.handlePaymentSuccess(
                    id,
                  );
                }
              },
            ),
          );
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
