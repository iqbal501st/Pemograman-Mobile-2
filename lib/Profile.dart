import 'package:flutter/material.dart';
import 'LoginPage.dart'; // Import file LoginPage.dart yang berisi halaman login
import 'SignupPage.dart'; // Import file SignupPage.dart yang berisi halaman sign up
import 'login.dart'; // Import file login.dart yang berisi halaman login
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green[900],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              if (_user != null) ...[
                SizedBox(height: 20),
                Text(
                  _user!.displayName ?? "",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _user!.email ?? "",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
              ],
              if (_user == null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.email, color: Colors.green[900]),
                          SizedBox(width: 10),
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.navigate_next, color: Colors.green[900]),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_user == null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.green[900]),
                          SizedBox(width: 10),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.navigate_next, color: Colors.green[900]),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_user != null)
                GestureDetector(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } catch (e) {
                      print("Error signing out: $e");
                    }
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.green[900]),
                          SizedBox(width: 10),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.navigate_next, color: Colors.green[900]),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
