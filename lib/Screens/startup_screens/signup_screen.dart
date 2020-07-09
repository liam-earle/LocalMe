import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  //Controllers
  TextEditingController _usernameController =  TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //Variables
  String _username;
  String _email;
  String _password;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              SizedBox(width: 50.0,),
              LogoWidget(
                logoHeight: 200.0,
                logoWidth: 200.0,
              ),

              //Username Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  prefixText: '@'
                ),
                controller: _usernameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
              ),
              
              //E-Mail Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email)
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
              ),

              //Password Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock)
                  ),
                  obscureText: true,
                  controller: _passwordController,
              ),
              
              //Sign Up Button
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () async {
                  
                  //Giving variables values
                  _username = _usernameController.text;
                  _email = _emailController.text;
                  _password = _passwordController.text;
                  
                  //Checking for required fields
                  if (_email == '' || _password == '' || _username == ''){
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Row(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text('  Enter required fields')
                          ],
                        ),
                      ),
                    );
                  }

                  //Create User
                  final firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

                  //User Database
                  CollectionReference usersDB = Firestore.instance.collection("Users");
                  usersDB.document(firebaseUser.user.uid).setData({"UID": firebaseUser.user.uid, "Username": _username, "Email": firebaseUser.user.email});
                  usersDB.document(firebaseUser.user.uid).collection("Friends");

                  //Add user to globals
                  globals.loggedInUser = firebaseUser.user;

                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("    Creating Account...")
                        ],
                      ),
                    ),
                  );

                  firebaseUser.user.sendEmailVerification();

                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("    Sending Verification Email")
                        ],
                      ),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 3));
                  
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("   Logging In...")
                      ],),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);
                },                                                                                                                                                            
              ),

              //"Login" Text and Login Button
              SizedBox(                                       
                height: 50.0,
              ),
              Text("Have an account? Click Here to Login!", style: TextStyle(fontSize: 10.0),),
              SizedBox(height: 5.0),
              ButtonTheme(
                minWidth: 10.0,
                height: 30.0,
                  child: RaisedButton(
                    child: Text("Login", style: TextStyle(fontSize: 10.0),),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 7.0,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/loginscreen');
                  },
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}