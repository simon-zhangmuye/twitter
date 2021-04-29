import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:twitter/utils/variables.dart';

import 'comment.dart';

class ViewUser extends StatefulWidget {
  final String uid;
  ViewUser(this.uid);

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  String uid;
  Stream userStream;
  String username;
  String profile;
  bool loading = true;

  @override
  initState() {
    super.initState();
    getViewUser();
  }

  getViewUser() async {
    DocumentSnapshot userdoc = await usercollection.doc(widget.uid).get();
    // print(userdoc.data());
    setState(() {
      username = userdoc.data()['username'];
      profile = userdoc.data()['profile'];
      loading = false;
    });
    getCurrentUser();
    getStream(widget.uid);
  }

  getCurrentUser() {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    // print(userdoc.data());
    setState(() {
      uid = firebaseuser.uid;
    });
  }

  getStream(String id) {
    setState(() {
      userStream = twittercollection.where(id).snapshots();
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

  followuser() async {
    var document = await usercollection
        .doc(widget.uid)
        .collection('followers')
        .doc(uid)
        .get();
    if (!document.exists) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.purple])),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 6,
                      left: MediaQuery.of(context).size.width / 2 - 64,
                    ),
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(profile),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.5,
                    ),
                    child: Column(
                      children: [
                        Text(
                          username,
                          style: mystyle(30, Colors.black, FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Following',
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                            Text(
                              'Followers',
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '123',
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                            Text(
                              '234',
                              style: mystyle(20, Colors.black, FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    colors: [Colors.lightBlue, Colors.blue])),
                            child: Center(
                              child: Text(
                                'Follow User',
                                style:
                                    mystyle(25, Colors.white, FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'User Twitters',
                          style: mystyle(25, Colors.black, FontWeight.w700),
                        ),
                        StreamBuilder<Object>(
                            stream: twittercollection.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
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
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: querySnapshot.size,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot twitterdoc =
                                      querySnapshot.docs[index];
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            twitterdoc.data()['profile']),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            twitterdoc.data()['username'],
                                            style: mystyle(20, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            timeAgo.format(twitterdoc
                                                .data()['time']
                                                .toDate()),
                                            style: mystyle(16, Colors.black,
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  if (twitterdoc
                                                          .data()['type'] ==
                                                      1)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        twitterdoc
                                                            .data()['twitter'],
                                                        style: mystyle(
                                                            20,
                                                            Colors.black,
                                                            FontWeight.w400),
                                                      ),
                                                    ),
                                                  if (twitterdoc
                                                          .data()['type'] ==
                                                      2)
                                                    Image.network(
                                                      twitterdoc
                                                          .data()['image'],
                                                      width: 300,
                                                      height: 300,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  if (twitterdoc
                                                          .data()['type'] ==
                                                      3)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            twitterdoc.data()[
                                                                'twitter'],
                                                            style: mystyle(
                                                                20,
                                                                Colors.black,
                                                                FontWeight
                                                                    .w400),
                                                          ),
                                                        ),
                                                        Image.network(
                                                          twitterdoc
                                                              .data()['image'],
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Comment(twitterdoc
                                                                            .data()[
                                                                        'id'])));
                                                      },
                                                      icon:
                                                          Icon(Icons.comment)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    twitterdoc
                                                        .data()['commentscount']
                                                        .toString(),
                                                    style: mystyle(18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        likepost(twitterdoc
                                                            .data()['id']);
                                                      },
                                                      icon: twitterdoc
                                                              .data()['likes']
                                                              .contains(uid)
                                                          ? Icon(Icons.favorite,
                                                              color: Colors
                                                                  .redAccent)
                                                          : Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color: Colors
                                                                  .redAccent)),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    twitterdoc
                                                        .data()['likes']
                                                        .length
                                                        .toString(),
                                                    style: mystyle(18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        sharepost(
                                                            twitterdoc
                                                                .data()['id'],
                                                            twitterdoc.data()[
                                                                'twitter']);
                                                      },
                                                      icon: Icon(Icons.share)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    twitterdoc
                                                        .data()['shares']
                                                        .toString(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
