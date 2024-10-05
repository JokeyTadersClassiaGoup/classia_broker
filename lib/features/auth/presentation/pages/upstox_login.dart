import 'dart:convert';

import 'package:classia_broker/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/utils/show_warning_toast.dart';

class UpstoxLogin extends StatefulWidget {
  static const routeName = 'upstox-login';
  const UpstoxLogin({super.key});

  @override
  State<UpstoxLogin> createState() => _UpstoxLoginState();
}

class _UpstoxLoginState extends State<UpstoxLogin> {
  late final WebViewController _webViewController;
  final String loginUrl =
      'https://api.upstox.com/v2/login/authorization/dialog';

  final String apiKey = 'fff80cf5-c2f2-4178-b8fa-cc34ec62f205';
  final String apiSecret = 'xf9bx39x81';

  final String redirectUri = 'https://127.0.0.1:5000/';

  // final String l = 'https://api.upstox.com/v2/login/authorization/dialog?response_type=code&client_id=$apiKey&redirect_uri=$redirectUri';

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  String? accessToken;

  String? code;

  @override
  void initState() {
    super.initState();
    final String url =
        'https://api.upstox.com/v2/login/authorization/dialog?response_type=code&client_id=$apiKey&redirect_uri=$redirectUri';
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url.startsWith(redirectUri)) {
              await _handleRedirect(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url)).catchError(
        (er) {
          print(er);
        },
      );
  }

  Future<void> _handleRedirect(String url) async {
    isLoading.value = true;
    final uri = Uri.parse(url);
    code = uri.queryParameters['code'];
    if (code != null) {
      accessToken = await _getAccessToken(code!);
      if (accessToken != null && mounted) {
        context.pushReplacementNamed(HomePageProvider.routeName,
            extra: accessToken as String);
        // Navigator.of(context).push(MaterialPageRoute(2
        //     builder: (context) => BottomNavBarPage(
        //           accessToken: accessToken!,
        //         )));
        isLoading.value = false;
      } else {
        showWarningToast(msg: 'Something went wrong');
      }
    }
    // context.pop();
  }

  Future<String?> _getAccessToken(String code) async {
    final url = Uri.parse(
      'https://api.upstox.com/v2/login/authorization/token',
    );
    try {
      final Response response = await http.post(
        url,
        body: {
          'code': code,
          'client_id': apiKey,
          'client_secret': apiSecret,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
      );
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('accessToken : ${responseBody['access_token']}');
        return responseBody['access_token'];
      } else {
        showWarningToast(msg: 'Failed to get access token: ${response.body}');
        return null;
      }
    } catch (e) {
      showWarningToast(msg: e.toString());
      return null;
    }
  }

// i gave two most expensive things free for you
// 1. Loyalty
// 2. Love

  @override
  void dispose() {
    super.dispose();
    isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, _, child) {
          return isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : WebViewWidget(
                  controller: _webViewController,
                );
        },
      ),
    );
  }
}
