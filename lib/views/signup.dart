import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/login.dart';

class SignupPage extends StatefulWidget {
  final Function toggle;
  SignupPage(this.toggle);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();
  String _error = "";
  final formKey = GlobalKey<FormState>();

  TextEditingController UserNameEditingController = new TextEditingController();

  TextEditingController EmailEditingController = new TextEditingController();

  TextEditingController PasswordEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        "name": UserNameEditingController.text,
        "email":EmailEditingController.text
      };
      HelperFunctions.saveUserNameSharedPreference(UserNameEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(EmailEditingController.text);

      setState((){
      isLoading = true;
      });

     authMethods.signUpWithEmailAndPassword(EmailEditingController.text, PasswordEditingController.text)
      .then((value){//print("${value.uid}");
        if(value == null){
          setState(() {
            _error = "User with this email Already exists";
            isLoading = false;

          });
        }else{

        dataBaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Dashboard()
      ));

      }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,

      ),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[

                  FadeAnimation(1,
                    Text("Sign up", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),)),
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
                  FadeAnimation(1.2, Text("Create an account, It's free", style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700]
                  ),)),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.1, makeInput(label: "User Name",EditingController: UserNameEditingController,widget_str: "Please enter a Valid Username",len_int: 4)),
                    FadeAnimation(   //email id
                        1.2,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Email id", style: TextStyle(
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
              FadeAnimation(1.5, Container(
                padding: EdgeInsets.only(top: 3, left: 3,bottom: 10),

                child: SignInButtonBuilder(
                  text: 'Sign up with Email',
                  icon: Icons.email,
                  onPressed: () {signMeUp();},
                  backgroundColor: Colors.blueGrey[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                )
              )),
              FadeAnimation(1.5, Container(
                padding: EdgeInsets.only(top: 3, left: 3,bottom: 10),

                child: SignInButton(
                  Buttons.Google,
                  onPressed: () async{ await authMethods.signUpWithGoogle(context);},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),


                ),
              )),
              FadeAnimation(1.5, Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 50.0, 0.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Already Have an Account?"),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Login",style: TextStyle(
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
        SizedBox(height: 30,),

      ],
    );
  }
}