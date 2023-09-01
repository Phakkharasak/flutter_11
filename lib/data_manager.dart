import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class DataManager {
  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('users_data') ?? '{"users":[]}';
    final jsonData = json.decode(data);
    final users = (jsonData['users'] as List<dynamic>)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    final existingUserIndex = users.indexWhere((u) => u.id == user.id);
    if (existingUserIndex != -1) {
      // Update existing user
      users[existingUserIndex] = user;
    } else {
      // Create new user with auto-generated ID
      final lastId = users.isNotEmpty ? users.last.id : 0;
      final newUser = User(
        id: lastId + 1,
        name: user.name,
        lastname: user.lastname,
        email: user.email,
        password: user.password,
      );
      users.add(newUser);
    }
    final jsonString =
        json.encode({'users': users.map((user) => user.toJson()).toList()});
    prefs.setString('users_data', jsonString);
  }
}
