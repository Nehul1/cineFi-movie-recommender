import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movierec/commons/loading.dart';
import 'package:movierec/data/get_movie_details.dart';
import 'package:movierec/pages/home_page.dart';

import '../commons/common.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool loading = true;
  List<String> docIDs=[];

  Future getDocId() async{
    await FirebaseFirestore.instance.collection('movies').orderBy("year_of_release",descending: true).get().then(
          (snapshot) => snapshot.docs.forEach(
              (document) {
            docIDs.add(document.reference.id);
          }),
    );
    loading=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9EC),
      // appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFFF9BE7C),
      appBar: new AppBar(elevation: 0.0, backgroundColor: Color(0xFF0D253F),
          title: Text('All Movies'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   color: Colors.transparent,
              //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //         "All Movies",
              //         style: TextStyle(
              //             color: Color(0xFF0D253F),
              //             fontSize: 20,
              //             fontWeight: FontWeight.w700,
              //             letterSpacing: 1.2),
              //       ),
              //       SizedBox(height: 5),
              //     ],
              //   ),
              // ),
              Expanded(
                  child: FutureBuilder(
                    future: getDocId(),
                    builder: (context,snapshot){
                      return loading==true? Loading(): ListView.builder(
                          itemCount: docIDs.length,
                          itemBuilder: (context, index)
                          {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetMovie(documentId: docIDs[index]),
                            );
                          }
                      );
                    },
                  )
              )
            ],
          )),
    );
  }
}
