import 'package:focused_menu/modals.dart';
import 'package:localmeapp/imports.dart';
import 'package:localmeapp/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: TabBar(
          controller: tabController,
          tabs: <Widget>[
            new Tab(icon: Icon(Icons.local_library)),
            new Tab(icon: Icon(Icons.location_city)),
            //new Tab(icon: Icon(Icons.people)),
            new Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          TodaysPaperScreen(),
          SubscriptionsFeedScreen(),
          //FriendsFeedScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
