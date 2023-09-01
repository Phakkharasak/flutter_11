import 'package:flutter/material.dart';
import 'package:flutter_11/data_manager.dart';

class User {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterPage extends StatefulWidget {
  final User? user;
  final Function(User)? onUpdateUser;

  const RegisterPage({Key? key, this.user, this.onUpdateUser})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String lastname = "";
  String email = "";
  String password = "";
  User? _updatedUser;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      name = widget.user!.name;
      lastname = widget.user!.lastname;
      email = widget.user!.email;
      password = widget.user!.password;
    } else if (_updatedUser != null) {
      name = _updatedUser!.name;
      lastname = _updatedUser!.lastname;
      email = _updatedUser!.email;
      password = _updatedUser!.password;
    }
  }

  void updateUser(User oldUser, User newUser) {
    setState(() {
      _updatedUser = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RainbowAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/564x/5a/bd/86/5abd863665263f4284081b34be8bd351.jpg',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                nameInputField(),
                SizedBox(height: 20.0),
                lastnameInputField(),
                SizedBox(height: 20.0),
                emailInputField(),
                SizedBox(height: 20.0),
                passwordInputField(),
                SizedBox(height: 20.0),
                submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Name:",
        hintText: "Enter your name",
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => name = newValue!,
    );
  }

  Widget lastnameInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Lastname:",
        hintText: "Enter your lastname",
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => lastname = newValue!,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email:",
        hintText: "Enter your email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (!value.contains('@')) {
          return "Invalid email format";
        }
        return null;
      },
      onSaved: (newValue) => email = newValue!,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password:",
        hintText: "Enter your password",
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => password = newValue!,
      obscureText: true,
    );
  }

  Widget submitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            registerUser();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "REGISTER",
            style: TextStyle(fontSize: 18, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newUser = User(
        id: 0,
        name: name,
        lastname: lastname,
        email: email,
        password: password,
      );
      DataManager.saveUserData(newUser);
      print("Name: $name");
      print("Lastname: $lastname");
      print("Email: $email");
      print("Password: $password");
      if (widget.onUpdateUser != null) {
        widget.onUpdateUser!(newUser);
      }
    }
  }
}

class RainbowAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100, // adjust the height as needed
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
        'REGISTER PAGE',
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
