import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:twitter/utils/variables.dart';

class Comment extends StatefulWidget {
  final String documentid;

  Comment(this.documentid);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController commentcontroller = TextEditingController();
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

  addComment() async {
    DocumentSnapshot userdoc = await usercollection.doc(uid).get();
    twittercollection.doc(widget.documentid).collection('comments').doc().set({
      'comment': commentcontroller.text,
      'username': userdoc.data()['username'],
      'uid': userdoc.data()['uid'],
      'profile': userdoc.data()['profile'],
      'time': DateTime.now()
    });
    DocumentSnapshot comment =
        await twittercollection.doc(widget.documentid).get();
    twittercollection
        .doc(widget.documentid)
        .update({'commentscount': comment.data()['commentscount'] + 1});
    commentcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments Page',
          style: mystyle(20),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 70,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: twittercollection
                      .doc(widget.documentid)
                      .collection('comments')
                      .snapshots(),
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
                        DocumentSnapshot commentdoc = querySnapshot.docs[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(commentdoc.data()['profile']),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      commentdoc.data()['username'],
                                      style: mystyle(20),
                                    ),
                                    Text(
                                      timeAgo.format(
                                          commentdoc.data()['time'].toDate()),
                                      style: mystyle(20),
                                    )
                                  ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                commentdoc.data()['comment'],
                                style:
                                    mystyle(16, Colors.grey, FontWeight.w300),
                              ),
                            ],
                          ),
                          // subtitle:
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    hintStyle: mystyle(20),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () {
                    addComment();
                  },
                  borderSide: BorderSide.none,
                  child: Text(
                    'Publish',
                    style: mystyle(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
