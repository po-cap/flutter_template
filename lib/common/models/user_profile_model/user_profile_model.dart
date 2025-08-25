
class UserProfileModel {
  int? id;
  String? avatar;
  String? displayName;
  String? banner;

  UserProfileModel({
    this.id,
    this.avatar, 
    this.displayName,
    this.banner
  });

  copyWith({
    String? avatar,
    String? displayName,
    String? banner
  }) {
    return UserProfileModel(
      id: id,
      avatar: avatar ?? this.avatar,
      displayName: displayName ?? this.displayName,
      banner: banner ?? this.banner
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      avatar: json['avatar'],
      displayName: json['displayName'],
      banner: json['banner']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'avatar': avatar,
    'displayName': displayName,
    'banner': banner
  };
}