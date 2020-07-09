import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class SubscriptionsFeedScreen extends StatefulWidget {
  @override
  _SubscriptionsFeedScreenState createState() => _SubscriptionsFeedScreenState();
}

class _SubscriptionsFeedScreenState extends State<SubscriptionsFeedScreen> {
  
  IconData selectedIcon = Icons.add;

  
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(centerTitle: true, title: new Column(children: <Widget>[SizedBox(height: 3.0,),Icon(Icons.location_city), Text('Cities',)],), automaticallyImplyLeading: false,),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.search), backgroundColor: Colors.white, foregroundColor: Colors.blue, onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil('/addfriendsscreen', (Route<dynamic> route) => false);},),
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: globals.currentUserDocRef.collection('Subbed_Cities').snapshots(),
              builder: (context, citiesSnapshots) {
                if(citiesSnapshots.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else
                {
                  return ListView.builder(
                    itemCount: citiesSnapshots.data.documents.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                 
                                StreamBuilder(
                                  stream: Firestore.instance.collection('Cities').document(citiesSnapshots.data.documents[index].documentID).snapshots(),
                                  builder: (context, nameSnapshot) {
                                    if(nameSnapshot.hasData == false) {
                                      return Text('Name Error');
                                    }
                                    else
                                    {
                                      return
                                      Row(children: <Widget>[
                                        SizedBox(width: 10.0, height: 80.0,), 
                                        CircleAvatar(backgroundImage: NetworkImage(nameSnapshot.data["CityImage"]),), 
                                        SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(nameSnapshot.data["Name"], style: TextStyle(fontSize: 20.0),),
                                            Text(nameSnapshot.data["Province"], style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),)
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              RaisedButton(
                                                onPressed: () => {
                                                  globals.selectedCity = citiesSnapshots.data.documents[index].documentID,
                                                  selectedIcon = Icons.check
                                                },
                                                child: new Icon(selectedIcon),
                                                shape: CircleBorder(),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
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