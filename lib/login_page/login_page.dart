import 'package:betting_app/consts/const_data.dart';
import 'package:betting_app/consts/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static final routeName = '/';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameCtrl;
  TextEditingController _phoneCtrl;
  @override
  void initState() {
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: FutureBuilder(
            initialData: null,
            future: SharedPreferences.getInstance()
                .then((value) => value.getString('isLogin')),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data != null) {
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.pushReplacementNamed(context, Routes.homePage,
                        arguments: snapshot.data);
                  });
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'images/background.jpg',
                      fit: BoxFit.fill,
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Center(
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'images/background.jpg',
                              fit: BoxFit.fill,
                            ),
                            Container(
                              color: Colors.black12,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildName(),
                                      buildPhoneNumber(),
                                      buildSubmit(context),
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
            }),
      ),
    );
  }

  Widget buildSubmit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.15,
        child: RaisedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (_formKey.currentState.validate()) {
              showDialog(
                context: context,
                child: Center(child: CircularProgressIndicator()),
              );
              userCollection
                  .where('phone', isEqualTo: _phoneCtrl.text)
                  .get()
                  .then((loginResult) {
                if (loginResult.docs.isNotEmpty) {
                  if (loginResult.docs[0]['name'] == _nameCtrl.text) {
                    SharedPreferences.getInstance().then((pref) {
                      pref.setString('isLogin', loginResult.docs[0].id);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.homePage,
                        arguments: loginResult.docs[0].id,
                      );
                    });
                  } else {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Invalide User'),
                        content: Text(
                            "User name and phone number not match. please enter correct user name."),
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("New Account Creation"),
                        content: Text("Would you like to create new account"),
                        actions: [
                          FlatButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Yes")),
                          FlatButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("No"))
                        ],
                      )).then((value) {
                    if (value ?? false) {
                      showDialog(
                        context: context,
                        child: Center(child: CircularProgressIndicator()),
                      );
                      userCollection.add({
                        'name': _nameCtrl.text,
                        'type': 'player',
                        'wallet': '0',
                        'phone': _phoneCtrl.text,
                      }).then((docResult) {
                        SharedPreferences.getInstance().then((pref) {
                          pref.setString('isLogin', docResult.id);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.homePage,
                            arguments: docResult.id,
                          );
                        });
                      });
                    }
                  });
                }
              });
            }
          },
          color: Colors.black,
          child: Text(
            "Let's Play!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _nameCtrl,
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value.isEmpty) return 'Enter your name.';
              return null;
            },
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              labelText: 'Name',
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: true,
            controller: _phoneCtrl,
            cursorColor: Colors.black,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value.isEmpty) return 'Enter Phone number';
              if (value.length != 10) return 'Enter valid Phone number';
              return null;
            },
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              labelText: 'Phone Number',
            ),
          ),
        ),
      ),
    );
  }
}
