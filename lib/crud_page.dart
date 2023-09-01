import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_11/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({Key? key}) : super(key: key);

  @override
  _CrudPageState createState() => _CrudPageState();
}

class RainbowAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        'CRUD PAGE',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _CrudPageState extends State<CrudPage> {
  List<User> users = [];
  User? _updatedUser;

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  Future<void> getUsersData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('users_data');
    if (data != null) {
      final jsonData = json.decode(data);
      final userList = (jsonData['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList();
      setState(() {
        users = userList;
      });
    }
  }

  void deleteUser(User user) {
    setState(() {
      users.remove(user);
      if (_updatedUser != null && _updatedUser!.id == user.id) {
        _updatedUser = null;
      }
    });
    saveUsersData();
  }

  void updateUser(User oldUser, User newUser) {
    setState(() {
      final index = users.indexOf(oldUser);
      if (index != -1) {
        users[index] = newUser;
      }
    });
    saveUsersData();
  }

  Future<void> saveUsersData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        json.encode({'users': users.map((user) => user.toJson()).toList()});
    prefs.setString('users_data', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RainbowAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/564x/6e/23/fa/6e23fa5a3436f534f4085d627cb196a0.jpg',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(
                  '${user.name} ${user.lastname}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.email,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              user: user,
                              onUpdateUser: (updatedUser) {
                                updateUser(user, updatedUser);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Delete User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 5,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteUser(user);
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
