import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mystyle(double size, [Color color, FontWeight fw]) {
  return GoogleFonts.montserrat(fontSize: size, fontWeight: fw, color: color);
}

CollectionReference usercollection =
    FirebaseFirestore.instance.collection('users');

CollectionReference twittercollection =
    FirebaseFirestore.instance.collection('twitter');

Reference pictures = FirebaseStorage.instance.ref().child('twitterpics');

var exampleimage =
    'https://www.diethelmtravel.com/wp-content/uploads/2016/04/bill-gates-wealthiest-person-279x300.jpg';
