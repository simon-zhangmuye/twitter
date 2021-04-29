import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/utils/variables.dart';

import '../view_user.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchresult;
  searchuser(String word) {
    var users =
        usercollection.where('username', isGreaterThanOrEqualTo: word).get();
    print(users);
    setState(() {
      searchresult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECE5DA),
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            filled: true,
            hintText: 'Search for users...',
            hintStyle: mystyle(18),
          ),
          onFieldSubmitted: searchuser,
        ),
      ),
      body: searchresult == null
          ? Center(
              child: Text(
                'Search for users....',
                style: mystyle(30),
              ),
            )
          : FutureBuilder(
              future: searchresult,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'Search for users....',
                      style: mystyle(30),
                    ),
                    // ignore: missing_return
                  );
                }
                QuerySnapshot querySnapshot = snapshot.data;
                return ListView.builder(
                    itemCount: querySnapshot.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = querySnapshot.docs[index];
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(user.data()['profile']),
                          ),
                          title: Text(
                            user.data()['username'],
                            style: mystyle(25),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewUser(user.data()['uid'])));
                            },
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.lightBlue,
                              ),
                              child: Center(
                                child: Text(
                                  'View',
                                  style: mystyle(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }),
    );
  }
}
