
import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

Future<bool> check(String newPdfPath, String oldPdfPath) async {

  //Regenerate calendar on new year - if still old one weeks are far ahead, if new one we make sure we have correct year set
  DateTime today = DateTime.now();
  if (today.day == 1 && today.month == 1)
    return false;

  File oldPDF = File(oldPdfPath);
  File newPDF = File(newPdfPath);

  var oldHash = md5.bind(oldPDF.openRead()).first;
  var newHash = md5.bind(newPDF.openRead()).first;

  return await oldHash == await newHash;
}