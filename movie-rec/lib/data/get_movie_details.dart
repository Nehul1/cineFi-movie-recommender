import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movierec/commons/loading.dart';

class GetMovie extends StatelessWidget {
  final String documentId;

  GetMovie({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference movies = FirebaseFirestore.instance.collection("movies");

    return FutureBuilder<DocumentSnapshot>(
      future:  movies.doc(documentId).get(),
        builder: ((context,snapshot) {
      if (snapshot.connectionState == ConnectionState.done){
        Map<String, dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
        // return ListTile(
        //   title: Text('Title: ${data['title']}'),
        //   subtitle: Text('Year of Release: ${data['year_of_release']}'),
        //   tileColor: Colors.grey[200],
        // );
        return Card(
          elevation: 0.0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5)),
          margin: new EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10),
          child: Container(
//            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10),
              // leading: SizedBox(
              //     height: 100.0,
              //     width: 100.0, // fixed width and height
              //     child: Image.asset("images/movie1.jpg")
              // ),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(data["image_url"].toString()),
              //   radius: 50,
              // ),
              title: Column(
                children: <Widget>[
                  Image(image: NetworkImage(data["image_url"].toString())),
                  SizedBox(height: 10,),
                  Wrap(
                    children: [
                      Text(
                        "Title: ",
                        style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),
                      ),
                      Text(
                        data['title'].toString(),
                        style: TextStyle(
                            fontSize: 16,color:Colors.black),
                      ),
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      Text("Release Year: ",
                          style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
                      Text(data['year_of_release'].toString(),
                        style: TextStyle(
                            fontSize: 14,color:Colors.black87),),
                    ],
                  ),
                ],
              ),
              // subtitle: Column(
              //   children: <Widget>[
              //     Row(
              //       children: <Widget>[
              //         Text("Year of Release : ",
              //             style: TextStyle(
              //                 fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
              //         Text(data['year_of_release'].toString(),
              //           style: TextStyle(
              //               fontSize: 14,color:Colors.black87),),
              //       ],
              //     ),
              //     // Row(
              //     //   children: <Widget>[
              //     //     Text("Genre : ",
              //     //         style: TextStyle(
              //     //             fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black)),
              //     //     Text(data['genre'].toString(),
              //     //       style: TextStyle(
              //     //           fontSize: 12,color:Colors.black87),),
              //     //   ],
              //     // ),
              //
              //   ],
              // ),
            ),
          ),
        );
      }

      return Loading();
    }));
  }
}
