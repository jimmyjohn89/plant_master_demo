//flutter imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//project files imports
import 'package:plant_master_demo/Theme/theme_data.dart';
import 'package:plant_master_demo/Theme/colors.dart';
import 'package:plant_master_demo/utils/fire_auth.dart';

import 'login_page.dart';

class SettingsScreen extends StatefulWidget {
  final User? user;
  SettingsScreen({required this.user});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  void viewSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {

      return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NAME: ${_currentUser.displayName}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0),
              Text(
                'EMAIL: ${_currentUser.email}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0),
              _currentUser.emailVerified
                  ? Text(
                'Email verified',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.green),
              )
                  : Text(
                'Email not verified',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red),
              ),
              SizedBox(height: 16.0),
              _isSendingVerification
                  ? CircularProgressIndicator()
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSendingVerification = true;
                      });
                      await _currentUser.sendEmailVerification();
                      setState(() {
                        _isSendingVerification = false;
                      });
                    },
                    child: Text('Verify email'),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);

                      if (user != null) {
                        setState(() {
                          _currentUser = user;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _isSigningOut
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('Sign out'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SafeArea(
          child: Column(
            children: [
               Text(
                  'Settings',
                  style: ThemeText.headerLarge,
               ),
              Spacer(),
              ElevatedButton(
                // Within the `FirstScreen` widget
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  //Navigator.pushNamed(context, '/');
                  viewSettings();
                },
                child: const Text('Settings'),
              ),
              Spacer(),
            ],
          ),
        ),
      );
  }
}