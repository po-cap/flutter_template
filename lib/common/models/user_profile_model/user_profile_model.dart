
class UserProfileModel {
  int? id;
  String? avatar;
  String? displayName;

  UserProfileModel({
    this.id,
    this.avatar, 
    this.displayName
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      avatar: json['avatar'],
      displayName: json['displayName']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'avatar': avatar,
    'displayName': displayName
  };
}