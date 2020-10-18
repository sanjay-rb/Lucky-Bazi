import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePlayer extends StatefulWidget {
  static final routeName = '/updatePlayer';
  final uid;
  final bool isProfile;

  UpdatePlayer({Key key, this.uid, this.isProfile}) : super(key: key);

  @override
  _UpdatePlayerState createState() => _UpdatePlayerState();
}

class _UpdatePlayerState extends State<UpdatePlayer> {
  String _dropDownData = 'player';
  final _addFormKey = GlobalKey<FormState>();
  var _nameCtrl = TextEditingController();
  var _phoneCtrl = TextEditingController();
  var _walletCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DocumentSnapshot doc = snapshot.data;
            _nameCtrl.text = doc.data()['name'];
            _phoneCtrl.text = doc.data()['phone'];
            _walletCtrl.text = doc.data()['wallet'];
            _dropDownData = doc.data()['type'];
            return Scaffold(
              appBar: AppBar(
                title:
                    widget.isProfile ? Text("Profile") : Text("Update Player"),
              ),
              body: Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _addFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _nameCtrl,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Please enter name";
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _phoneCtrl,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Please enter phone number";
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                ),
                                if (!widget.isProfile)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _walletCtrl,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Please enter amount";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        labelText: 'Wallet amount',
                                      ),
                                    ),
                                  ),
                                if (!widget.isProfile)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      value: _dropDownData,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Player"),
                                          value: 'player',
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Admin"),
                                          value: 'admin',
                                        ),
                                      ],
                                      onChanged: (value) {
                                        _dropDownData = value;
                                      },
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                  child: widget.isProfile
                                      ? Text("Update")
                                      : Text("Update Player"),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_addFormKey.currentState.validate()) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.uid)
                                          .update({
                                        'name': _nameCtrl.text,
                                        'type': _dropDownData,
                                        'wallet': _walletCtrl.text,
                                        'phone': _phoneCtrl.text,
                                      }).then((value) async {
                                        Navigator.pop(context);
                                        bool result = await showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            title: Text(
                                                "Player updated successfully!"),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: Text('OK'),
                                              )
                                            ],
                                          ),
                                        );
                                        if (result) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
