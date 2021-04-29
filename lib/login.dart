import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/signup.dart';

import 'utils/variables.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();

  login() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text, password: passwordcontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Flutter',
                style: mystyle(30, Colors.white, FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Login',
                style: mystyle(25, Colors.white, FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 64,
                height: 64,
                child: Image.asset('assets/images/flutter.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Email',
                    labelStyle: mystyle(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Password',
                    labelStyle: mystyle(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => login(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Login',
                  style: mystyle(20, Colors.black, FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: mystyle(20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup())),
                    child: Text(
                      'Register!',
                      style: mystyle(20, Colors.purple, FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
