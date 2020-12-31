import 'dart:developer';

import 'package:background_locator_example/Global.dart';
import 'package:background_locator_example/Providers/ProviderFirebase.dart';
import 'package:background_locator_example/Providers/ProviderPreferences.dart';
import 'package:background_locator_example/Screens/AdminPage/AdminMain.dart';
import 'package:flutter/material.dart';
import 'package:background_locator_example/Screens/TrackerScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  bool isError;
  bool isLoading;
  GlobalKey<FormState> _key;

  @override
  void initState() {
    _key = GlobalKey<FormState>();
    isLoading = false;
    isError = false;
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/logo.png',
              //   height: 140,
              //   width: 140,
              // ),
              Container(
                height: 140,
              ),
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: "Username"),
                        validator: (value) {
                          if (value.isEmpty) return 'Cannot be Empty';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value.isEmpty) return 'Cannot be Empty';
                          return null;
                        },
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(isError ? "Invalid Username OR Password" : "",
                    style: TextStyle(color: Colors.red)),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  elevation: 10,
                  color: Colors.teal,
                  onPressed: () {
                    if (_key.currentState.validate() && !isLoading) {
                      isLoading = true;
                      if (_usernameController.text == "admin") {
                        ProviderFirebase.login('admin', 'thespeedproject')
                            .then((creds) {
                          isLoading = true;
                          log("logged in ${creds.user.uid}");
                          Global.isAdmin = true;
                          ProviderPreferences.adminToggle(true);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminMain()),
                              (route) => false);
                        }).catchError((onError) {
                          isLoading = false;
                          setState(() {
                            isError = true;
                          });
                        });
                      } else {
                        ProviderFirebase.login(_usernameController.text,
                                _passwordController.text)
                            .then((value) {
                          isLoading = true;
                          //Acquire firebase stuff

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackerScreen()),
                              (route) => false);
                        }).catchError((onError) {
                          isLoading = false;
                          setState(() {
                            isError = true;
                          });
                        });
                      }
                    }
                  },
                  child: Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
