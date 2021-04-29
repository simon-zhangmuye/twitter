import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:twitter/utils/variables.dart';

import '../add_twitter.dart';
import '../comment.dart';

class Twitter extends StatefulWidget {
  Twitter({Key key}) : super(key: key);

  @override
  _TwitterState createState() => _TwitterState();
}

class _TwitterState extends State<Twitter> {
  String uid;

  @override
  initState() {
    super.initState();
    getCurrentUserId();
  }

  getCurrentUserId() {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseuser.uid;
    });
  }

  likepost(String documentid) async {
    DocumentSnapshot document = await twittercollection.doc(documentid).get();
    if (document.data()['likes'].contains(uid)) {
      twittercollection.doc(documentid).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      twittercollection.doc(documentid).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  sharepost(String documentid, String twitter) async {
    Share.text('twitter', twitter, 'text/plain');
    DocumentSnapshot document = await twittercollection.doc(documentid).get();
    twittercollection
        .doc(documentid)
        .update({'shares': document.data()['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Twitter',
              style: mystyle(20, Colors.white, FontWeight.w700),
            ),
            SizedBox(
              width: 5,
            ),
            Image(
              width: 40,
              height: 40,
              image: AssetImage('assets/images/flutter.png'),
            ),
          ],
        ),
        actions: [
          Icon(
            Icons.star,
            size: 32,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTwitter()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<Object>(
          stream: twittercollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Connection Error',
                style: mystyle(20),
              ));
            }
            QuerySnapshot querySnapshot = snapshot.data;
            return ListView.separated(
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) {
                DocumentSnapshot twitterdoc = querySnapshot.docs[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(twitterdoc.data()['profile']),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          twitterdoc.data()['username'],
                          style: mystyle(20, Colors.black, FontWeight.w600),
                        ),
                        Text(
                          timeAgo.format(twitterdoc.data()['time'].toDate()),
                          style: mystyle(16, Colors.black, FontWeight.w400),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                if (twitterdoc.data()['type'] == 1)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      twitterdoc.data()['twitter'],
                                      style: mystyle(
                                          20, Colors.black, FontWeight.w400),
                                    ),
                                  ),
                                if (twitterdoc.data()['type'] == 2)
                                  Image.network(
                                    twitterdoc.data()['image'],
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  ),
                                if (twitterdoc.data()['type'] == 3)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          twitterdoc.data()['twitter'],
                                          style: mystyle(20, Colors.black,
                                              FontWeight.w400),
                                        ),
                                      ),
                                      Image.network(
                                        twitterdoc.data()['image'],
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Comment(
                                                  twitterdoc.data()['id'])));
                                    },
                                    icon: Icon(Icons.comment)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  twitterdoc.data()['commentscount'].toString(),
                                  style: mystyle(18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      likepost(twitterdoc.data()['id']);
                                    },
                                    icon:
                                        twitterdoc.data()['likes'].contains(uid)
                                            ? Icon(Icons.favorite,
                                                color: Colors.redAccent)
                                            : Icon(Icons.favorite_border,
                                                color: Colors.redAccent)),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  twitterdoc.data()['likes'].length.toString(),
                                  style: mystyle(18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      sharepost(twitterdoc.data()['id'],
                                          twitterdoc.data()['twitter']);
                                    },
                                    icon: Icon(Icons.share)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  twitterdoc.data()['shares'].toString(),
                                  style: mystyle(18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }),
    );
  }
}
