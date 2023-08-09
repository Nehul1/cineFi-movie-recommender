import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movierec/auth/auth_page.dart';
import 'package:movierec/commons/common.dart';
import 'package:movierec/commons/topcontainer.dart';
import 'package:movierec/data/get_user_names.dart';
import 'package:movierec/pages/account.dart';
import 'package:movierec/pages/login_page.dart';
import 'package:movierec/pages/movies.dart';
import 'package:movierec/pages/recommendation.dart';
import 'package:movierec/pages/show_recommendations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs=[];

  Future getDocId() async{
    await FirebaseFirestore.instance.collection('users').get().then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                docIDs.add(document.reference.id);
            }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
    // appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFFF9BE7C),
      appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFF0D253F),
         title: Text('CineFi'),
          iconTheme: new IconThemeData(color: Color(0xFFFFF9EC)),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Color(0xFFFFF9EC),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ]),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(user.email.toString()),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF0D253F),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: Color(0xFF0D253F),
              ),
            ),

            //body
            InkWell(
              onTap: () {
                // changeScreenReplacement(context, HomePage());
              },
              child: ListTile(
                title: Text(
                  'Home Page',
                ),
                leading: Icon(
                  Icons.home,
                  color: Color(0xFF0D253F),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, MoviePage());
              },
              child: ListTile(
                title: Text(
                  'Movies',
                ),
                leading: Icon(
                  Icons.play_circle,
                  color: Color(0xFF0D253F),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, Recommender());
              },
              child: ListTile(
                title: Text(
                  'Recommended Movies',
                ),
                leading: Icon(
                  Icons.forward,
                  color: Color(0xFF0D253F),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                changeScreen(context, Account());
              },
              child: ListTile(
                title: Text(
                  'My Account',
                ),
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF0D253F),
                ),
              ),
            ),

            Divider(),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: ListTile(
                title: Text('Log out'),
                leading: Icon(
                  Icons.transit_enterexit,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          CarouselSlider(
            items: [
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/RRR.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/john_wick.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie3.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/avatar.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie4.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/avengers1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie5.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/avengers2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("images/movie6.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            options: CarouselOptions(
              height: 380.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
//         TopContainer(width:0,padding: EdgeInsets.symmetric(horizontal: 20.0),
//         height: 120,
// //            height: 44.5*SizeConfig.widthMultiplier,
//         child: Column(
// //                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 0, vertical: 0.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     CircleAvatar(
//                       backgroundColor: Colors.blue,
// //                          radius: 14*SizeConfig.widthMultiplier,
//                       radius: 40,
//                       backgroundImage: AssetImage(
//                         "images/accnt1.png",
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
// //                                  Container(
//                         Text(
//                           user.displayName.toString(),
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             fontSize: 25,
//                             color: Color(0xFF0D253F),
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
// //                                  ),
//                         Row(
//                           children: <Widget>[
//                             Icon(
//                               Icons.email,
// //                                    color: Colors.green,
// //                                    size: 30.0,
//                             ),
//                             Text(
//                               user.email.toString(),
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black45,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ]),
//       ),
      Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Categories",
              style: TextStyle(
                  color: Color(0xFF0D253F),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      Container(
//        height: 90 * SizeConfig.widthMultiplier,
        height: 400,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
                    height: 180,
                    width: MediaQuery.of(context).size.width/2,
                    child: Card(
                      color: Colors.blue,
                      margin: EdgeInsets.all(
                          5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.play_circle_outline_rounded),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                              ),
                            ),
                            Text('All'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Movies'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    changeScreen(context, MoviePage());
                  },
                ),
                InkWell(
                  child: Container(
//                    height: 44.5*SizeConfig.widthMultiplier,
                    height: 180,
                    width: MediaQuery.of(context).size.width/2,
                    child: Card(
                      color: Colors.redAccent,
                      margin: EdgeInsets.all(
                          5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.favorite_outlined),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                              ),
                            ),
                            Text('Recommended'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Movies'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    changeScreen(context, Recommender());
                  },
                ),
              ],
            ),
          ],
        ),
        ),
        ],
      ),
    );
  }
}
