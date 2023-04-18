class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String photoUrl;

  const UserModel({
    required this.userId,
    required this.email,
    required this.photoUrl,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "email": email,
      "photoUrl": photoUrl,
    };
  }
}
