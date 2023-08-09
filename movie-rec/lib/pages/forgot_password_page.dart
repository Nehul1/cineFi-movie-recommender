import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Please check your email for password reset link"),
        );
      });
    } on FirebaseAuthException catch (e){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFF0D253F),
          title: Text('CineFi'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                "Enter your email address for a password reset link",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white,),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          // MaterialButton(
          //   onPressed: passwordReset,
          //   child: Text(
          //       "Reset Password",
          //       style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18,
          //       ),
          //   ),
          //   color: Color(0xFF0D253F),
          // )
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: passwordReset,
              child: Container(
                  padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(color: Colors.deepPurple[400],
                  decoration: BoxDecoration(color: Color(0xFF0D253F),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
              ),
            ),
          ),

        ],
      ),
    );
  }
}
