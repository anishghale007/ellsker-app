class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String photoUrl;
  final String token;
  final int age;
  final String instagram;
  final String location;

  const UserModel({
    required this.userId,
    required this.email,
    required this.photoUrl,
    required this.userName,
    required this.token,
    required this.age,
    required this.instagram,
    required this.location,
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
    };
  }
}
