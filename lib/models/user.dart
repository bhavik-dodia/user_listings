import 'package:flutter/foundation.dart';

/// User data model.
class User {
  final int id;
  final String firstName, lastName, email, avatar;

  User({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.avatar,
  });

  /// Converts User object into json.
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'firs_name': firstName,
        'last_name': lastName,
        'email': email,
        'avatar': avatar,
      };

  /// Creates User object from json.
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        avatar: json['avatar'],
      );
}
