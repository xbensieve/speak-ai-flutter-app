class LoginResponse {
  final int statusCode;
  final String message;
  final bool isSuccess;
  final LoginResult? result;

  LoginResponse({
    required this.statusCode,
    required this.message,
    required this.isSuccess,
    this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      result:
          json['result'] != null ? LoginResult.fromJson(json['result']) : null,
    );
  }
}

class LoginResult {
  final String accessToken;
  final String refreshToken;

  LoginResult({required this.accessToken, required this.refreshToken});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
