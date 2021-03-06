import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class TodaysPaperScreen extends StatefulWidget {
  @override
  _TodaysPaperScreenState createState() => _TodaysPaperScreenState();
}

//Today's Paper Categories List and Object
class Category {
  final String name;
  final IconData icon;

  Category({this.name, this.icon});

  static List<Category> allCategories() {
    var lstofCategories = new List<Category>();

    //index 1
    lstofCategories.add(new Category(name: "People", icon: Icons.person));
    //index 2
    lstofCategories.add(new Category(name: "News", icon: Icons.local_library));
    //index 3
    lstofCategories.add(new Category(name: "Events", icon: Icons.event));
    //index 4
    lstofCategories.add(new Category(name: "Businesses", icon: Icons.store));

    return lstofCategories;
  }
}

//Post Card Types
class TextCard extends StatelessWidget {
  String postText;
  String posterName;
  String category;

  TextCard({this.postText, this.posterName, this.category});

  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 10.0),
                Text(
                  posterName,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, top: 5.0),
            width: 330.0,
            child: Text(postText),
          ),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  String imageLink;

  String imageDescription;

  String posterName;

  String category;

  ImageCard({this.imageLink, this.imageDescription, this.posterName});

  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 10.0),
                Text(
                  posterName,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            width: 330.0,
            height: 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(imageLink), fit: BoxFit.contain),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            width: 330.0,
            child: Text(imageDescription),
          ),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }
}

/* Eventually do the Link - Post code.....

class LinkCard extends StatelessWidget {

}
*/

//Today's Paper Main Screen
class _TodaysPaperScreenState extends State<TodaysPaperScreen> {
  final List<Category> _allCategories = Category.allCategories();

  var currentPageValue = 0.0;

  PageController pageController = PageController();

  //Category Card Setup
  Widget _getItemUI(BuildContext context, int index) {
    return new Card(
      color: Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0, width: 100.0),
          CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(_allCategories[index].icon)),
          Text(
            _allCategories[index].name,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }

  //Display Categories
  getCategories(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      itemCount: _allCategories.length,
      itemBuilder: _getItemUI,
    );
  }

  //Main Screen Layout
  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    //Category Selection
    switch (currentPageValue.round()) {
      case 0:
        globals.selectedCategory = "People";
        break;
      case 1:
        globals.selectedCategory = "News";
        break;
      case 2:
        globals.selectedCategory = "Events";
        break;
      case 3:
        globals.selectedCategory = "Businesses";
        break;
    }
    return new Scaffold(
      backgroundColor: Colors.blue,
      appBar: new AppBar(
        centerTitle: true,
        title: new Column(
          children: <Widget>[
            SizedBox(
              height: 3.0,
            ),
            Icon(Icons.local_library),
            Text('Today\'s Paper in ' + globals.selectedCity)
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Stack(
        children: <Widget>[
          Container(
            height: 100.0,
            child: getCategories(context),
          ),
          Container(
              margin: EdgeInsets.only(top: 100.0),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("Cities")
                      .document(globals.selectedCity)
                      .collection("Posts")
                      .where("Category", isEqualTo: globals.selectedCategory)
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    return ListView.builder(
                      itemCount: postSnapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        switch (postSnapshot.data.documents[index]["Type"]) {
                          case "Image":
                            return new ImageCard(
                              imageLink: postSnapshot.data.documents[index]
                                  ["ImageLink"],
                              imageDescription: postSnapshot
                                  .data.documents[index]["ImageDescription"],
                              posterName: postSnapshot.data.documents[index]
                                  ["PosterName"],
                            );
                            break;

                          case "Text":
                            return new TextCard(
                              postText: postSnapshot.data.documents[index]
                                  ["PostText"],
                              posterName: postSnapshot.data.documents[index]
                                  ["PosterName"],
                            );
                            break;
/*
                        case "Link":
                          return new LinkCard(

                          );
                          break;
*/
                        }
                      },
                    );
                  })),
        ],
      ),
      floatingActionButton: FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuOffset: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
              title: Text("Text Post"),
              trailingIcon: Icon(Icons.text_fields),
              onPressed: () {}),
          FocusedMenuItem(
              title: Text("Image Post"),
              trailingIcon: Icon(Icons.image),
              onPressed: () {}),
        ],
        onPressed: () {},
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.black26, spreadRadius: 5)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add),
              maxRadius: 30.0,
            )),
      ),
    );
  }
}
