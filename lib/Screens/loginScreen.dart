import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googlemaps/Provider/UserProvider.dart';
import 'package:googlemaps/Screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemaps/Provider/modelHud.dart';
import 'package:googlemaps/Screens/signup.dart';
import 'package:googlemaps/Screens/waitingWidget.dart';
import 'package:googlemaps/Widgets/customTextFormField.dart';
import 'package:googlemaps/Widgets/customtext.dart';
import 'package:googlemaps/constants.dart';
import 'package:googlemaps/models/user.dart';
import 'package:googlemaps/servecies/auth.dart';
import 'package:googlemaps/servecies/store.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class loginScreen extends StatefulWidget {
  static String id = 'login';

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _auth = Auth();

  final auth1  = FirebaseAuth.instance;

  String _email, _password;


  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  FacebookLogin facebookLogin = FacebookLogin();
  Future<FirebaseUser> getUser() async {
    return await auth1.currentUser();
  }



  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      child: Scaffold(
        backgroundColor: constants.whitecolor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<modelHud>(context).isloading,
          child: Form(
            key: _globalKey,
            child: Stack(
              children: <Widget>[
                SvgPicture.asset(
                  constants.backgoungimage,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    height: height,
                    width: width,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 5),
                          child: Container(
                            width: width * 0.2,
                            child: SvgPicture.asset(constants.icon),
                          ),
                        ),
                        //text
                        Center(
                            child: customText(
                                fontWeight: FontWeight.bold,
                                textcolor: constants.blackcolor,
                                size: 20,
                                text: "Teenagers Hangouts")),
                        //text
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                                child: customText(
                                  text: "Your Way ",
                                  fontWeight: FontWeight.normal,
                                  textcolor: constants.blackcolor,
                                  size: 13,
                                )),
                          ),
                        ),
                        //text
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                              child: FittedBox(
                                child: customText(
                                    fontWeight: FontWeight.bold,
                                    textcolor: constants.blackcolor,
                                    size: 20,
                                    text: "Find new place \n        now!"),
                              )),
                        ),
                        //custom text field for username
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          child: customTextFormField(
                            hint: "Email",
                            iconData: Icons.email,
                            onclick: (value) {
                              _email = value;
                            },
                          ),
                        ),
                        //custom text for password
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          child: customTextFormField(
                              hint: "Password",
                              iconData: Icons.vpn_key,
                              onclick: (value) {
                                _password = value;
                              }),
                        ),
                        //login button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Builder(
                            builder: (context) => FlatButton(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () async {
                                UserProvider userprovider = Provider.of<UserProvider>(context,listen: false);
                                final modelhud = Provider.of<modelHud>(context,listen: false);
                                if (_globalKey.currentState.validate()) {
                                  _globalKey.currentState.save();
                                  modelhud.isprogressloding(true);
                                  try {
                                    final authResult = await _auth
                                        .sign_in_with_email_and_password(
                                        _email.trim(), _password.trim());

                                    modelhud.isprogressloding(false);
                                    Navigator.pushNamed(context, waitngWidget.id);
                                    print(authResult.user.uid);
                                  } on PlatformException catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        e.message.toString(),

                                        style: TextStyle(fontFamily: 'font'),
                                      ),
                                    ));
                                    modelhud.isprogressloding(false);
                                  }
                                }
                              },
                              color: constants.primarycolor,
                              child: customText(
                                text: "Login",
                                textcolor: constants.blackcolor,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                        Center(
                            child: customText(
                              text: "Or Login With",
                              size: 16,
                              textcolor: constants.blackcolor,
                              fontWeight: FontWeight.normal,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              GestureDetector(
                                onTap:() async {
                                  Store store = Store();
                                  UserProvider userprovider = Provider.of<UserProvider>(context,listen: false);
                                  FacebookLoginResult facebookLoginResult = await facebookLogin.logIn();

                                  final FacebookAccessToken accessToken = facebookLoginResult.accessToken;

                                  AuthCredential authCredential = FacebookAuthProvider.getCredential(accessToken: accessToken.token);

                                  FirebaseUser user;
                                  try{
                                    user = (await auth1.signInWithCredential(authCredential)).user;
                                    userprovider.getaccesstoken(accessToken.token);

                                    final DocumentSnapshot doc =
                                    await Firestore.instance.collection(constants.usercollection).document(user.uid).get();
                                    if(!doc.exists) {
                                      store.adduserfacebook(User(
                                          user.displayName, null, user.uid),
                                          user.uid);
                                    }

                                    Navigator.pushNamed(context, waitngWidget.id);
                                  }catch(e){
                                    print(e.toString());
                                  }finally{
                                    if(user != null){
                                      print(user.displayName);
                                      print("https://graph.facebook.com/v2.12/me?fields=picture.height(200)&access_token=${facebookLoginResult.accessToken.token}");
                                      print(user.phoneNumber);
                                      print(user.email);


                                      // ignore: missing_return
                                    }
                                  }
                                }

                                ,
                                child: Container(
                                    width: width * 0.4,
                                    height: height * 0.07,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: constants.facebookcolor,
                                    ),
                                    child: Center(
                                      child: customText(
                                        text: "Facebook",
                                        size: 16,
                                        textcolor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              Builder(
                                builder: (context)=> GestureDetector(
                                  onTap: () async {
                                    final GoogleSignIn googleSignIn = GoogleSignIn();
                                    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                                    final GoogleSignInAuthentication googleSignInAuthentication =
                                    await googleSignInAccount.authentication;

                                    final AuthCredential credential = GoogleAuthProvider.getCredential(
                                      accessToken: googleSignInAuthentication.accessToken,
                                      idToken: googleSignInAuthentication.idToken,
                                    );

                                    final AuthResult authResult = await auth1.signInWithCredential(credential);
                                    final FirebaseUser user = authResult.user;
                                    assert(!user.isAnonymous);
                                    assert(await user.getIdToken() != null);

                                    final FirebaseUser currentUser = await auth1.currentUser();
                                    if(currentUser !=null){
                                      Store store = Store();
                                      final DocumentSnapshot doc =
                                      await Firestore.instance.collection(constants.usercollection).document(user.uid).get();
                                      if(!doc.exists) {
                                        store.adduserfacebook(User(
                                            user.displayName, null, user.uid),
                                            user.uid);
                                      }
                                      Navigator.pushNamed(context, home.id);
                                    }

                                  },
                                  child: Container(
                                      width: width * 0.4,
                                      height: height * 0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: constants.googlecolor,
                                      ),
                                      child: Center(
                                        child: customText(
                                          text: "Google",
                                          size: 16,
                                          textcolor: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: customText(
                            text: "Don't Have An Account?",
                            size: 11,
                            textcolor: constants.blackcolor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, signup.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontFamily: 'font',
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: constants.blackcolor),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}