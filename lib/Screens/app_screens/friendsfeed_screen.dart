import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class FriendsFeedScreen extends StatefulWidget {
  @override
  _FriendsFeedScreenState createState() => _FriendsFeedScreenState();
}

class _FriendsFeedScreenState extends State<FriendsFeedScreen> {

  //variables
  var searchInput;

  IconData friendaddIcon;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.search), backgroundColor: Colors.white, foregroundColor: Colors.blue, onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/addfriendsscreen', (Route<dynamic> route) => false);},),
      appBar: new AppBar(centerTitle: true, title: new Column(children: <Widget>[SizedBox(height: 3.0,),Icon(Icons.people), Text('Friends',)],), automaticallyImplyLeading: false,),
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: globals.usersDB.document(globals.loggedInUser.uid).collection('Friends').snapshots(),
              builder: (context, friendsSnapshots) {
                if(friendsSnapshots.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else
                {
                  return ListView.builder(
                    itemCount: friendsSnapshots.data.documents.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(width: 10.0, height: 80.0,), 
                                CircleAvatar(backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/localmeapp-7f2ed.appspot.com/o/Users%2FDefaultProfile.png?alt=media&token=63674059-4707-4d5e-9bd0-509da8f7dea5'),), 
                                SizedBox(width: 10.0), 
                                StreamBuilder(
                                  stream: Firestore.instance.collection('Users').document(friendsSnapshots.data.documents[index]["UID"]).snapshots(),
                                  builder: (context, nameSnapshot) {
                                    if(nameSnapshot.hasData == false) {
                                      return Text('Name Error');
                                    }
                                    else
                                    {
                                      return
                                      Text(nameSnapshot.data["Name"], style: TextStyle(fontSize: 20.0),);
                                    }
                                  }
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            )
          )
        ]
      )
    );
  }
}