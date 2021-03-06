import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //Variables
  var _email;
  var _password;
  bool isChecked = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _rememberLogin() async {
    if (isChecked == true) {
      print(globals.loggedInUser);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("Email", _email);
      prefs.setString("Password", _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Use this for the Logo
                LogoWidget(
                  logoWidth: 250.0,
                  logoHeight: 250.0,
                ),

                //E-Mail Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  controller: _emailController,
                ),

                //Password Field
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  controller: _passwordController,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Remember Me"),
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            isChecked = value;
                          });
                        }),
                  ],
                ),

                //Login Button
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Builder(builder: (BuildContext loginButtonContext) {
                      return RaisedButton(
                        child: Text('Login'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 7.0,
                        onPressed: () async {
                          _email = _emailController.text;
                          _password = _passwordController.text;

                          try {
                            final firebaseUser = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password);
                            if (firebaseUser.user.isEmailVerified == true) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Row(
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      Text("   Logging In....")
                                    ],
                                  ),
                                ),
                              );
                              globals.loggedInUser = firebaseUser.user;

                              _rememberLogin();

                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/homescreen',
                                  (Route<dynamic> route) => false);
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => SimpleDialog(
                                  title: Text(
                                      "Your email address is not verified"),
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24.0,
                                              top: 16.0,
                                              bottom: 16.0),
                                          child: Text(
                                              "Would you like another verification email to be sent?"),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("No"),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            firebaseUser.user
                                                .sendEmailVerification();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (e) {
                            final snackBar = SnackBar(
                              content: Text("Email or Password incorrect"),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                              duration: Duration(seconds: 3),
                            );
                            Scaffold.of(loginButtonContext)
                                .showSnackBar(snackBar);
                          }
                        },
                      );
                    })),
                SizedBox(
                  height: 100.0,
                ),
                ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child: RaisedButton(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 10.0),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 7.0,
                    onPressed: () {},
                  ),
                ),
                //"Don't Have an Account" Text and Sign Up Button
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  "Don\'t have an account?",
                  style: TextStyle(fontSize: 10.0),
                ),
                SizedBox(height: 5.0),
                ButtonTheme(
                  minWidth: 10.0,
                  height: 30.0,
                  child: RaisedButton(
                    child: Text(
                      "Sign Up Here!",
                      style: TextStyle(fontSize: 10.0),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 7.0,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signupscreen');
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
