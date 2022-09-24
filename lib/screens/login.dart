import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tejaswini_admin/constants.dart';
import 'package:tejaswini_admin/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      if (user != null) {
        Navigator.pushNamed(context, '/dash');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("User not found"),
        ));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("wrong password"),
        ));
        print('Wrong password provided.');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      shape: StadiumBorder(),
      backgroundColor: container,
      content: Text("Login Success"),
    ));
    return user;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      Navigator.pushNamed(context, '/dash');
    }
    return firebaseApp;
  }

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Container(
                      height: 600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                              color: text,
                              content: "Login",
                              size: 30,
                              weight: FontWeight.w600),
                          Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      color: text,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                controller: email,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: text,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: text)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: text, width: 2)),
                                  focusColor: text,
                                  hintText: "Enter your email",
                                  hintStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: text,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                keyboardType: TextInputType.visiblePassword,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      color: text,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                obscureText: true,
                                controller: pass,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: text,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: text)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: text, width: 2)),
                                  focusColor: text,
                                  hintText: "Enter your pass",
                                  hintStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: text,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: container,
                                    ),
                                    onPressed: () {
                                      signInUsingEmailPassword(
                                          email: email.text.toString(),
                                          password: pass.text.toString(),
                                          context: context);

                                      email.clear();
                                      pass.clear();
                                    },
                                    child: CustomText(
                                        color: text,
                                        content: "Login",
                                        size: 20,
                                        weight: FontWeight.bold)),
                                SizedBox(height: 20),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: container,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: CustomText(
                                        color: text,
                                        content: "Register",
                                        size: 20,
                                        weight: FontWeight.bold)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
