import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tejaswini_admin/constants.dart';
import 'package:tejaswini_admin/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();

  Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
      print("registration success");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        shape: StadiumBorder(),
        backgroundColor: container,
        content: Text("Register Success"),
      ));
      Navigator.pushNamed(context, '/dash');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("Weak password"),
        ));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("Account already exists"),
        ));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                      color: text,
                      content: "Register",
                      size: 30,
                      weight: FontWeight.w600),
                  Column(
                    children: [
                      TextField(
                        controller: name,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              letterSpacing: 0.5,
                              color: text,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        decoration: InputDecoration(
                          labelText: "Name",
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
                              borderSide: BorderSide(color: text, width: 2)),
                          focusColor: text,
                          hintText: "Enter your name",
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
                        controller: email,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              letterSpacing: 0.5,
                              color: text,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
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
                              borderSide: BorderSide(color: text, width: 2)),
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
                        controller: pass1,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              letterSpacing: 0.5,
                              color: text,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        obscureText: true,
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
                              borderSide: BorderSide(color: text, width: 2)),
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
                      SizedBox(height: 20),
                      TextField(
                        controller: pass2,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              letterSpacing: 0.5,
                              color: text,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Re Enter passowrd",
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
                              borderSide: BorderSide(color: text, width: 2)),
                          focusColor: text,
                          hintText: "Confirm password",
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
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: container,
                      ),
                      onPressed: () async {
                        if (pass1.text.toString() == pass2.text.toString()) {
                          await registerUsingEmailPassword(
                            name: name.text.toString(),
                            email: email.text.toString(),
                            password: pass1.text.toString(),
                          );
                        } else {
                          print("mis match");
                        }
                      },
                      child: CustomText(
                          color: text,
                          content: "Register",
                          size: 20,
                          weight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
