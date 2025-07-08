import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:template/common/index.dart';
import 'package:url_launcher/url_launcher.dart';

class OAuthService extends GetxService {
  
  // 这是一个单例写法
  static OAuthService get to => Get.find();

  late final AppLinks _appLinks = AppLinks();

  // 配置參數
  String? _clientId;
  String? _redirectUri;
  String? _authorizationEndpoint;
  String? _tokenEndpoint;
  List<String> _scopes = ['openid','profile','email'];

  // 狀態變量
  String? _codeVerifier;
  String? _codeChallenge;
  String? _state;
  StreamSubscription<Uri>? _linkSubscription;

    // 回調函數
  Function(Map<String, dynamic>)? _onTokenReceived;
  Function(String)? _onError;

  // 初始化方法（替代構造函數）
  void initialize({
    required String redirectUri,
    List<String>? scopes,
    Function(Map<String, dynamic>)? onTokenReceived,
    Function(String)? onError,
  }) async {
    _clientId = String.fromEnvironment('CLIENT_ID');
    _redirectUri = redirectUri;
    _authorizationEndpoint = Constants.authorizeEndpoint;
    _tokenEndpoint = Constants.tokenEndpoint;
    _scopes = scopes ?? _scopes;
    _onTokenReceived = onTokenReceived;
    _onError = onError;
  }


  // 生成隨機字符串
  static String _generateRandomString([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values).substring(0, length);
  }

  // 生成 code verifier
  String _generateCodeVerifier() {
    return _generateRandomString(32);
  }

  // 生成 code challenge
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  // 生成 state 參數（防CSRF）
  String _generateState() {
    return _generateRandomString(32);
  }

  // 構建授權 URL
  String _buildAuthorizationUrl() {
    _codeVerifier = _generateCodeVerifier();
    _codeChallenge = _generateCodeChallenge(_codeVerifier!);
    _state = _generateState();
    
    final params = {
      'response_type': 'code',
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'scope': _scopes.join(' '),
      'code_challenge': _codeChallenge,
      'code_challenge_method': 'S256',
      'state': _state,
    };
    
    final queryString = Uri(queryParameters: params).query;
    return '$_authorizationEndpoint?$queryString';
  }

    // 啟動授權流程
  Future<void> launchAuthorizationFlow() async {
    final authorizationUrl = _buildAuthorizationUrl();
    
    if (await canLaunchUrl(Uri.parse(authorizationUrl))) {
      await launchUrl(
        Uri.parse(authorizationUrl),
        mode: _getPlatformLaunchMode(), // 自動選擇平台最佳模式
        webOnlyWindowName: '_blank',    // 僅Web有效
      );
    } else {
      throw Exception('Could not launch $authorizationUrl');
    }
  }

  LaunchMode _getPlatformLaunchMode() {
    // 根據平台選擇最佳模式
    if (Platform.isIOS) {
      return LaunchMode.externalApplication; // iOS強制用Safari
    } else if (Platform.isAndroid) {
      return LaunchMode.externalApplication; // Android強制用默認瀏覽器
    }
    return LaunchMode.platformDefault; // 其他平台
  }

 // 處理深度鏈接（應用啟動時調用）
void handleIncomingLinks() {
  // 處理冷啟動
  _appLinks.getInitialLink().then((Uri? uri) {
    if (uri != null) _handleAuthCallback(uri);
  });

  // 處理熱啟動
  _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) _handleAuthCallback(uri);
  }, onError: (err) {
    _onError?.call('Link handling error: $err');
  });
}

  // 處理授權回調
  void _handleAuthCallback(Uri uri) {
    // 驗證 state 參數
    final state = uri.queryParameters['state'];
    if (state != _state) {
      _onError?.call('State parameter mismatch');
      return;
    }
    
    final error = uri.queryParameters['error'];
    if (error != null) {
      _onError?.call('Authorization failed: $error');
      return;
    }
    
    final code = uri.queryParameters['code'];
    if (code != null && _codeVerifier != null) {
      _exchangeCodeForToken(code);
    }
  }

  // 交換授權碼獲取令牌
  Future<void> _exchangeCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint ?? ''),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
          'client_id': _clientId,
          'code_verifier': _codeVerifier!,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        _onTokenReceived?.call(tokenData);
      } else {
        _onError?.call('Token exchange failed: ${response.body}');
      }
    } catch (e) {
      _onError?.call('Token exchange error: $e');
    }
  }

  // 刷新令牌
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint ?? ''),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _clientId,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Refresh token error: $e');
    }
  }

  // 清理資源
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _codeVerifier = null;
    _codeChallenge = null;
    _state = null;
  }
}