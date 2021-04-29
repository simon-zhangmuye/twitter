import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'utils/variables.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();

  signup() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailcontroller.text, password: passwordcontroller.text)
        .then((signeduser) => usercollection.doc(signeduser.user.uid).set({
              'uid': signeduser.user.uid,
              'email': emailcontroller.text,
              'password': passwordcontroller.text,
              'username': usernamecontroller.text,
              'profile':
                  'https://t4.ftcdn.net/jpg/03/32/59/65/360_F_332596535_lAdLhf6KzbW6PWXBWeIFTovTii1drkbT.jpg'
            }));
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
                'Get Start to Flutter',
                style: mystyle(30, Colors.white, FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Register',
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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Username',
                    labelStyle: mystyle(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => signup(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Register',
                  style: mystyle(20, Colors.black, FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I agree to',
                    style: mystyle(20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Terms())),
                    child: Text(
                      'Terms of policy',
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

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('terms'),
    );
  }
}
