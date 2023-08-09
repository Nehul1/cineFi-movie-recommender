import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movierec/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}): super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async{
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(),);
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e){
      Navigator.of(context).pop();

      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.play_circle_outline_rounded,
                  //   size: 100,
                  // ),
                  Image(image: AssetImage("images/movie_icon1.png"),height: 200,),
                  SizedBox(height: 20,),
                  Text("Movie Recommender",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: Color(0xFF0D253F)
                    )
                  ),
                  SizedBox(height: 20),
                  Text("One Place for finding perfect movies",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0D253F),
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white,),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    // child: Material(
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   color: Colors.grey.withOpacity(0.2),
                    //   elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            icon: Icon(Icons.alternate_email),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            icon: Icon(Icons.lock_outline),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ForgotPassword();
                            }));
                          },
                          child: Text("Forgot Password?",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        // decoration: BoxDecoration(color: Colors.deepPurple[400],
                        decoration: BoxDecoration(color: Color(0xFF0D253F),
                        borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                              'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text("Register now",
                          style: TextStyle(
                              color: Colors.blue,
                            fontWeight: FontWeight.bold
                          ),),
                      )
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        )
      );
  }
}