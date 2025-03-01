import '../entity/user.dart';

class UserModel extends User {
  UserModel({
    required super.uId,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap(String id) {
    return {
      'uId': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
