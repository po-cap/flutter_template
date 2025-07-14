
class UserLoginReq {

  String email;
  String password;

  UserLoginReq({
    required this.email, 
    required this.password
  });

  factory UserLoginReq.fromJson(Map<String, dynamic> json) {
    return UserLoginReq(
      email: json['email'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password
  };
}