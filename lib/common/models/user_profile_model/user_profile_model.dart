
class UserProfileModel {
  String? avatar;
  String? displayName;

  UserProfileModel({
    this.avatar, 
    this.displayName
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      avatar: json['avatar'],
      displayName: json['displayName']
    );
  }

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'displayName': displayName
  };
}