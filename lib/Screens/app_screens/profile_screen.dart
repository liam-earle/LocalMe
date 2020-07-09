import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  FirebaseUser user = globals.loggedInUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(centerTitle: true, title: new Column(children: <Widget>[SizedBox(height: 3.0,),Icon(Icons.person), Text('Profile',)],), automaticallyImplyLeading: false,),
      key: _scaffoldKey,
      body: new Stack(
      children: <Widget>[

        //Divider for Map Header
        Divider(
          height: MediaQuery.of(context).size.height / 2.1,
          color: Colors.black,
        ),

        Positioned(
          width: 300.0,
          top: MediaQuery.of(context).size.height / 4.5,
          child: Row(
            children: <Widget>[
              
              //Profile Picture
              SizedBox(width: 20.0),
              Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: NetworkImage('https://scontent-ort2-1.cdninstagram.com/vp/134f69e33a554af790d923a94c57ccfd/5C477C81/t51.2885-19/s150x150/22637673_151186885620943_3877570996806352896_n.jpg'),
                          fit: BoxFit.cover
                          ),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7.0, 
                          color: Colors.black
                          )
                      ])
                    ),
              
              //Display Name
              SizedBox(                                     
                width: 20.0,
              ),
                StreamBuilder(
                  stream: globals.currentUserDocRef.snapshots(),
                  builder: (context, snapshots) {
                    if(snapshots.hasData == false) {
                      return CircularProgressIndicator();
                    }
                    else
                    {
                      return Text(snapshots.data['Name'], style: TextStyle(fontSize: 25.0,),);
                    }
                  }
                ), 
              ],
            )
          ),
        ],
      ) 
    );
  }
}