class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String photoUrl;
  final String token;
  final String age;
  final String instagram;
  final String location;
  final bool isOnline;
  final bool inCall;

  const UserModel({
    required this.userId,
    required this.email,
    required this.photoUrl,
    required this.userName,
    required this.token,
    required this.age,
    required this.instagram,
    required this.location,
    required this.isOnline,
    required this.inCall,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "username": userName,
      "email": email,
      "photoUrl": photoUrl,
      'token': token,
      "age": age,
      "instagram": instagram,
      "location": location,
      "isOnline": isOnline,
      "inCall": inCall,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      userName: json['username'],
      token: json['token'],
      age: json['age'],
      instagram: json['instagram'],
      location: json['location'],
      isOnline: json['isOnline'],
      inCall: json['inCall'],
    );
  }
}
