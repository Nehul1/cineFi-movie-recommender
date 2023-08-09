import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movierec/commons/common.dart';
import 'package:movierec/commons/loading.dart';
import 'package:movierec/pages/show_recommendations.dart';
import 'package:movierec/pages/show_recommendations_by_movie.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Recommender extends StatefulWidget {
  const Recommender({Key? key}) : super(key: key);

  @override
  State<Recommender> createState() => _RecommenderState();
}

class _RecommenderState extends State<Recommender> {
  final _movieController = TextEditingController();

  List<String> genres= ['action', 'adventure', 'animation', 'children',
    'comedy', 'crime', 'documentary', 'drama', 'fantasy', 'film-noir',
    'horror', 'imax', 'musical', 'mystery', 'romance', 'sci-fi', 'thriller',
    'war', 'western'];
  List<String> selectedGenres = [];

  final user = FirebaseAuth.instance.currentUser!;

  int userID=0;

  Future getUserID() async{
    await FirebaseFirestore.instance.collection('users').
    where('email', isEqualTo: user.email.toString())
        .snapshots().listen(
            (data) =>  userID=data.docs[0]['userID']
    );
  }

  Future sendRequest() async{
    await FirebaseFirestore.instance.collection("recommender").doc("input").set({
      'userID': userID,
      'genres': FieldValue.arrayUnion(selectedGenres),
    });
  }

  Future sendMovieRequest() async{
    await FirebaseFirestore.instance.collection("recommender").doc("movie_input").set({
      'userID': userID,
      'title': _movieController.text.trim(),
    });
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
      // appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFFF9BE7C),
      appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFF0D253F),
          title: Text('Recommended Movies'),
          iconTheme: new IconThemeData(color: Color(0xFFFFF9EC)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFFFF9EC)),
              onPressed: () => Navigator.of(context).pop()),
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
      body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Pick Genres",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white,),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: MultiSelectDialogField(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12)
                        ),
                        // buttonText: Text("Genre"),
                        items: genres.map((e) => MultiSelectItem(e, e)).toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          selectedGenres = values;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (){
                      sendRequest();
                      // Future.delayed(Duration(seconds: 10), (){
                      //   Loading();
                        changeScreen(context, ShowRecommendations());
                      // });
                      },
                    child: Container(
                        padding: EdgeInsets.all(20),
                        // decoration: BoxDecoration(color: Colors.deepPurple[400],
                        decoration: BoxDecoration(color: Color(0xFF0D253F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Get Recommendations By Genre',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Pick movie",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white,),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    // child: Material(
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   color: Colors.grey.withOpacity(0.2),
                    //   elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _movieController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter favourite movie',
                          suffixIcon: Icon(Icons.favorite_outline,),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (){
                      sendMovieRequest();
                      changeScreen(context, ShowRecommendationsByMovie());
                    },
                    child: Container(
                        padding: EdgeInsets.all(20),
                        // decoration: BoxDecoration(color: Colors.deepPurple[400],
                        decoration: BoxDecoration(color: Color(0xFF0D253F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Get Recommendations By Movie',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          )),
    );

  }
}
