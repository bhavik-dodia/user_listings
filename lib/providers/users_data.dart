import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';

/// Provides methods to manage users data.
class UsersData extends ChangeNotifier {
  List<User> _users = [];

  get users => UnmodifiableListView(_users);
  get usersCount => _users.length;

  String _currentUser = '';

  set currentUser(value) => _currentUser = value;
  get currentUser => _currentUser;

  /// Fetches and sets the users from api.
  Future<void> fetchUsers() async {
    try {
      final response = await APIService.makeGetRequest();
      final data = jsonDecode(response.body)['data'] as List;
      _users = data.map((user) => User.fromJson(user)).toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// Adds new user to api.
  Future<void> addUser(User user) async {
    try {
      final response = await APIService.makePostRequest(user.toJson());
      _users.add(
        User(
          id: int.parse(jsonDecode(response.body)['id']),
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          avatar: user.avatar,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// Deletes a specific user form api.
  Future<void> deleteUser(User user) async {
    try {
      _users.remove(user);
      notifyListeners();
      await APIService.makeDeleteRequest(user.id);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
