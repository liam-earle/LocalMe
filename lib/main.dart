import 'package:localmeapp/imports.dart';

void main() => runApp(new LocalMe());

class LocalMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'LocalMe',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ProductSans'
      ),
      home: CheckLogin(),
      routes: <String, WidgetBuilder> {
        '/homescreen': (BuildContext context) => new HomeScreen(),
        '/signupscreen': (BuildContext context) => new SignUpScreen(),
        '/loginscreen': (BuildContext context) => new LoginScreen(),
        '/addfriendsscreen': (BuildContext context) => new AddFriendsScreen(),
      }
    );
  }
}

