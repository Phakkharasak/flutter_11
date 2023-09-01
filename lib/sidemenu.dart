import 'package:flutter/material.dart';
import 'register.dart';
import 'crud_page.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 242, 238, 224),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'MENU',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 32.0,
                    backgroundImage: NetworkImage(
                        'https://atlas-content-cdn.pixelsquid.com/stock-images/hippo-cartoon-hippopotamus-4o7X0r1-600.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phakkharasak Ponsanong',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            menuItem(Icons.home, 'Home', () {}),
            menuItem(Icons.person_add, 'Register', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            }),
            menuItem(Icons.list, 'CRUD', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrudPage()),
              );
            }),
            menuItem(Icons.logout, 'Logout', () {}),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.indigo, size: 28.0),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.indigo,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.all(15.0),
    );
  }
}
