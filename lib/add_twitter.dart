import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/utils/variables.dart';

class AddTwitter extends StatefulWidget {
  AddTwitter({Key key}) : super(key: key);

  @override
  _AddTwitterState createState() => _AddTwitterState();
}

class _AddTwitterState extends State<AddTwitter> {
  File imagepath;
  TextEditingController twittercontroller = TextEditingController();
  bool uploading = false;

  pickImage(imagesource) async {
    final image = await ImagePicker().getImage(source: imagesource);
    setState(() {
      imagepath = File(image.path);
    });
    print(imagepath);
    Navigator.pop(context);
  }

  optionsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                child: Text(
                  'Image from gallery',
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                child: Text(
                  'Image from camera',
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: mystyle(20),
                ),
              ),
            ],
          );
        });
  }

  uploadimage(String id) async {
    UploadTask uploadTask = pictures.child(id).putFile(imagepath);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadurl = await taskSnapshot.ref.getDownloadURL();

    return downloadurl;
  }

  postTwitter() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    var alldocuments = await twittercollection.get();
    int length = alldocuments.docs.length;
    // 3 conditions
    //only twitter
    if (twittercontroller.text != '' && imagepath == null) {
      twittercollection.doc('Twitter $length').set({
        'username': userdoc.data()['username'],
        'profile': userdoc.data()['profile'],
        'uid': firebaseuser.uid,
        'id': 'Twitter $length',
        'twitter': twittercontroller.text,
        'likes': [],
        'shares': 0,
        'commentscount': 0,
        'type': 1,
        'time': DateTime.now()
      });
    }
    //only image
    if (twittercontroller.text == '' && imagepath != null) {
      String imageurl = await uploadimage('Twitter $length');
      twittercollection.doc('Twitter $length').set({
        'username': userdoc.data()['username'],
        'profile': userdoc.data()['profile'],
        'uid': firebaseuser.uid,
        'id': 'Twitter $length',
        'image': imageurl,
        'likes': [],
        'shares': 0,
        'commentscount': 0,
        'type': 2,
        'time': DateTime.now()
      });
    }
    //twitter and image
    if (twittercontroller.text != '' && imagepath != null) {
      String imageurl = await uploadimage('Twitter $length');
      twittercollection.doc('Twitter $length').set({
        'username': userdoc.data()['username'],
        'profile': userdoc.data()['profile'],
        'uid': firebaseuser.uid,
        'id': 'Twitter $length',
        'twitter': twittercontroller.text,
        'image': imageurl,
        'likes': [],
        'shares': 0,
        'commentscount': 0,
        'type': 3,
        'time': DateTime.now()
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 32,
          ),
        ),
        title: Text(
          'Add Twitter',
          style: mystyle(20),
        ),
        actions: [
          InkWell(
            onTap: () {
              optionsDialog();
            },
            child: Icon(
              Icons.photo,
              size: 40,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => postTwitter(),
        child: Icon(
          Icons.publish,
          size: 32,
        ),
      ),
      body: uploading == false
          ? Column(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: twittercontroller,
                  maxLines: null,
                  style: mystyle(20),
                  decoration: InputDecoration(
                      labelText: 'What is happening now',
                      labelStyle: mystyle(25),
                      border: InputBorder.none),
                )),
                imagepath == null
                    ? Container()
                    : MediaQuery.of(context).viewInsets.bottom > 0
                        ? Container()
                        : Image(
                            width: 200,
                            height: 200,
                            image: FileImage(imagepath),
                          ),
              ],
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Uploading....',
                  style: mystyle(25),
                )
              ],
            )),
    );
  }
}
