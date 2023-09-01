import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_11/login_result.dart';
import 'sidemenu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: rainbowAppBar(),
        drawer: SideMenu(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://i.pinimg.com/564x/45/75/54/4575549c61fbea9c26fb7c816cecaf8f.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: LoginScreen(),
        ),
      ),
    );
  }
}

AppBar rainbowAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
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
      'LOGIN PAGE',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),
    centerTitle: true,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  Future<void> loginState(email, password) async {
    var parameter = {
      "email": email,
      "password": password,
    };
    var uri = Uri.http("172.16.1.214", "users", parameter);
    var resp = await http.get(uri);
    var _loginResult = loginResultFromJson(resp.body);
    if (_loginResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 10),
                Text("INVALID EMAIL OR PASSWORD",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text("LOGIN SUCCESSFUL", style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            emailInputField(),
            SizedBox(height: 20.0),
            passwordInputField(),
            SizedBox(
              height: 20.0,
            ),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailInputField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email:",
        hintText: "Input your email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "THIS FIELD IS REQUIRED FOR EMAIL";
        }
        if (!EmailValidator.validate(value)) {
          return "INVALID EMAIL FORMAT";
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
        hintText: "Input your password",
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "THIS FIELD IS REQUIRED FOR PASSWORD";
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
            loginState(email, password);
            print("$email, $password");
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
            "CONFIRM",
            style: TextStyle(fontSize: 18, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }
}
