import 'dart:convert';

import 'package:user_profile_management/core/connection.dart';
import 'package:user_profile_management/core/endpoint.dart';
import 'package:user_profile_management/core/shared_preferences.dart';
import 'package:user_profile_management/model/dio_response.dart';
import 'package:user_profile_management/model/user.dart';
import 'package:flutter/material.dart';

class UsersController extends ChangeNotifier {
  final List<User> _users = [];

  UsersController() {
    _loadUsersFromSharedPreferences();
  }

  Future<void> _loadUsersFromSharedPreferences() async {
    String? data = SharedPreference.getString(key: "users");
    if (data != null) {
      for (var e in (jsonDecode(data) as List)) {
        _users.add(User.fromJson(e));
      }
    }
  }

  Future<void> _saveUsersToSharedPreferences() async {
    String encodedUsers =
        jsonEncode(_users.map((user) => user.toJson()).toList());
    await SharedPreference.setString(key: "users", value: encodedUsers);
  }

  Future<int> addUser(User user) async {
    try {
      DioResponse res = await Connection.instance
          .post(url: Endpoint.users, data: user.toJson());
      if (res.status == 1) {
        _users.add(user);
        await _saveUsersToSharedPreferences();
        notifyListeners();
        return 1;
      } else {
        throw Exception("Failed to add user: ${res.error}");
      }
    } catch (e) {
      throw Exception("Failed to add user: ${e.toString()}");
    }
  }

  Future<int> removeUser(User user) async {
    try {
      DioResponse res =
          await Connection.instance.delete(url: Endpoint.users, id: user.id!);
      if (res.status == 1) {
        _users.remove(user);
        await _saveUsersToSharedPreferences();
        notifyListeners();
        return 1;
      } else {
        throw Exception("Failed to remove user: ${res.error}");
      }
    } catch (e) {
      throw Exception("Failed to remove user: ${e.toString()}");
    }
  }

  Future<int> updateUser(User oldUser, User newUser) async {
    try {
      final index = _users.indexOf(oldUser);
      if (index != -1) {
        DioResponse res = await Connection.instance.patch(
            url: "${Endpoint.users}/${oldUser.id}", data: newUser.toJson());
        if (res.status == 1) {
          _users[index] = newUser;
          await _saveUsersToSharedPreferences();
          notifyListeners();
          return 1;
        } else {
          throw Exception("Failed to update user: ${res.error}");
        }
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Failed to update user: ${e.toString()}");
    }
  }

  Future<DioResponse> fetchUsers() async {
    try {
      DioResponse res = await Connection.instance.get(url: Endpoint.users);
      if (res.status == 1) {
        _users.clear();
        for (var e in res.data!) {
          _users.add(User.fromJson(e));
        }
        await _saveUsersToSharedPreferences();
        notifyListeners();
      }
      return res;
    } catch (e) {
      throw Exception("Failed to fetch users: ${e.toString()}");
    }
  }

  List<User> get users => _users;
}
