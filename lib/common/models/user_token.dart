
class UserTokenModel {
  String tokenType;
  String accessToken;
  String refreshToken;
  int? expiresIn;
  
  UserTokenModel({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      tokenType: json['token_type'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_type': tokenType,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}