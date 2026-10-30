import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bottom.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  TextEditingController mail=TextEditingController();
  TextEditingController pass=TextEditingController();
  Future<void> signin()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mail.text, password: pass.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successfully"),
          backgroundColor: Colors.green,),);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Bottom()));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed $e"),
          backgroundColor: Colors.red,),);
    }
  }
  Future googlesignin()async {
    final google = GoogleSignIn();
    try{

      final user = await google.signIn().catchError((onError){});
      if(user == null)return;
      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken:auth.idToken
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successfull"),
        backgroundColor: Colors.green,));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed$e"),
        backgroundColor: Colors.red,));

    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: AssetImage("lib/image/admin logo.jpeg"))
                  ),
                ),
              ),
              Container(
                height: 450,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),child: Padding(
                padding: const EdgeInsets.only(top: 40,left: 17,right: 20),
                child: Column(
                  children: [
                    TextField (
                      controller: mail,

                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Enter your email address",labelStyle: TextStyle(fontWeight: .w800),
                          label: Text("Email address")
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField (
                        controller: pass,

                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Enter your password",labelStyle: TextStyle(fontWeight: .w800),
                            label: Text("Password")
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 155),
                      child: Text("Forgot password?",style: TextStyle(fontSize: 18,color: Colors.blueAccent,fontWeight: .w800),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,right: 1),
                      child: GestureDetector (
                        onTap: () {
                          setState(() {
                            signin();
                          });
                        },
                        child: Container(
                          height: 47,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),child: Padding(
                          padding: const EdgeInsets.only(left: 125,top: 10),
                          child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),),
                        ),

                        ),
                      ),
                    ),



                  ],
                ),

              ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


