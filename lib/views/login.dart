import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/signup.dart';
import 'package:productivityapp/services/auth.dart';

class LoginPage extends StatefulWidget {
  final Function toggle;
  LoginPage(this.toggle);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot snapshotUserInfo;
  String _error = "";

  final formKey = GlobalKey<FormState>();
  TextEditingController EmailEditingController = new TextEditingController();

  TextEditingController PasswordEditingController = new TextEditingController();
  signIn(){
    if(formKey.currentState.validate()){
      setState((){
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(EmailEditingController.text, PasswordEditingController.text)
          .then((value){//print("${value.uid}");
        if(value != null) {
          dataBaseMethods.getUserByUserEmail(EmailEditingController.text)
              .then((val){
            snapshotUserInfo = val;
            HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data['name']);
            HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data['email']);
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Dashboard()
          ));
        }else{
          setState(() {
            _error = "  Either User does not exist or email or password is wrong";
            isLoading = false;

          });

        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,

      ),
      body: isLoading ? Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ):Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(1, Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:10),
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/collab.png"),
                              radius: 40.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text("Collab", style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ],
                      )),
                      FadeAnimation(
                        1,Container(
                        child: _error.isEmpty
                            ? Container()
                            : Container(

                          color: Colors.grey[100],
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    _error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                      SizedBox(height: 20,),

                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(   //email id
                              1.2,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Email", style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87
                                  ),),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    validator: (val){return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val) ? null:"Please Provide a valid Email Id"; },
                                    controller: EmailEditingController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey[400])
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey[400])
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              )
                          ),
                          FadeAnimation(1.3, makeInput(label: "Password", obscureText: true,EditingController: PasswordEditingController,widget_str: "Please enter a Valid Password with 6+ characters",len_int: 6)),

                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(1.5, Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 50.0, 0.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Forgot Password?",
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),

                      ],
                    ),
                  )),

                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),

                        child: SignInButtonBuilder(
                          text: '           Sign in ',
                          icon: Icons.lock_open,
                          onPressed: () {signIn();},
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                        )
                    ),
                  )),


                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),

                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () async{ await authMethods.signUpWithGoogle(context);},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),


                        )
                    ),
                  )),

                  FadeAnimation(1.5, Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 50.0, 0.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Don't Have an Account?"),
                        GestureDetector(

                          onTap: (){
                            widget.toggle();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Register Now",style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),),
                          ),
                        )

                      ],
                    ),
                  )),

                ],
              ),
            ),
            FadeAnimation(1.2, Container(
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover
                  )
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false,EditingController,String widget_str,int len_int}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          validator: (val){return val.isEmpty || val.length < len_int ? widget_str: null ;},
          controller: EditingController,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 0,),
      ],
    );
  }
}