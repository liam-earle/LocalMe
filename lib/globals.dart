library localmeapp.globals;

import 'package:localmeapp/imports.dart';

//Current User

FirebaseUser loggedInUser;

CollectionReference usersDB = Firestore.instance.collection("Users");

DocumentReference currentUserDocRef = usersDB.document(loggedInUser.uid);

//Posts
String selectedCategory;

String selectedCity = "none";
