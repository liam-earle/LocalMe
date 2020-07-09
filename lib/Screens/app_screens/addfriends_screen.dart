import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class AddFriendsScreen extends StatefulWidget {
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  
  //controllers
  TextEditingController _searchController = TextEditingController();

  //variables
  var searchInput;
  IconData friendaddIcon;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.arrow_back), onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/homescreen', (Route<dynamic> route) => false);}),
      appBar: new AppBar(centerTitle: true, title: new Column(children: <Widget>[SizedBox(height: 3.0,),Icon(Icons.people), Text('Friends',)],), automaticallyImplyLeading: false,),
      body: Stack(
        children: <Widget>[
          Container(
            height: 50.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search For a Friend to add',
                prefixIcon: Icon(Icons.people)
              ),
              controller: _searchController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50.0),
            child: StreamBuilder(
              stream: globals.usersDB.where('Username', isEqualTo: _searchController.text).snapshots(),
              builder: (context, snapshots) {
                if(snapshots.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else
                {
                  return ListView.builder(
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(height: 20.0,), 
                                CircleAvatar(backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/localmeapp-7f2ed.appspot.com/o/Users%2FDefaultProfile.png?alt=media&token=63674059-4707-4d5e-9bd0-509da8f7dea5'), radius: 70.0,),
                                SizedBox(height: 20.0,), 
                                Text(snapshots.data.documents[index]['Name'], style: TextStyle(fontSize: 20.0)),
                                Text(snapshots.data.documents[index]['Username'], style: TextStyle(fontSize: 15.0, color: Colors.grey, fontStyle: FontStyle.italic)),
                                SizedBox(height: 20.0,),
                                FloatingActionButton(child: Icon(Icons.add), onPressed: () {
                                  if(snapshots.data.documents[index]['UID'] == globals.loggedInUser.uid)
                                  {
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Row(
                                          children: <Widget>[
                                            Icon(Icons.error),
                                            Text('   Whooops! You can\'t add yourself!')
                                          ],
                                        ),
                                      )
                                    );
                                  }
                                  else
                                  {
                                    globals.usersDB.document(globals.loggedInUser.uid)
                                    .collection("Friends")
                                    .document(snapshots.data.documents[index]["UID"])
                                    .setData(
                                        {
                                          "UID": snapshots.data.documents[index]["UID"], 
                                          "Username": snapshots.data.documents[index]["Username"]
                                        }
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.0,),
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