import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../commons/loading.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final user = FirebaseAuth.instance.currentUser!;
  String user_first_name = "";
  String user_last_name = "";
  bool loading =true;

  Future getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: user.email.toString())
        .get()
        .then((snapshot) =>
              addUserName(snapshot.docs[0]["first_name"],snapshot.docs[0]["last_name"])
            );
    loading=false;
  }

  void addUserName(String fname, String lname){
    user_first_name=fname;
    user_last_name=lname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xFF0D253F),
            title: Text('Account Details'),
            iconTheme: new IconThemeData(color: Color(0xFFFFF9EC)),
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Color(0xFFFFF9EC),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  })
            ]),
        body: Column(children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(
                'images/accnt.png',
                // imageUrl.toString(),
                height: 150.0,
              ),
            ),
          ),
          FutureBuilder(
              future: getUserDetails(),
              builder: (context, snapshot) {
                return loading==true? Loading(): Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
//            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                          decoration: BoxDecoration(color: Colors.blueGrey),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            title: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      "First Name :",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      user_first_name,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Last Name :",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      user_last_name,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Email : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text(
                                      user.email.toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
        ]));
  }
}
