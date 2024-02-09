import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';

class PersonalInfos {
  final CollectionReference _personalInfoRef =
      FirebaseFirestore.instance.collection("personal_info");

  Future<bool> savePersonalInfos(
    BuildContext context,
    String? name,
    String? email,
  ) async {
    bool res = true;
    await _personalInfoRef.doc().set({
      "id": _personalInfoRef.doc().id,
      "name": name,
      "email": email,
      "gender": "",
      "phone": "",
      "profile_photo_url": "",
      "created_at": 1,
      "modified_at": 1,
    }).catchError((error) {
      res = false;
      CustomSnackBar.showSnackBar(
        context,
        "Something went wrong. Please try again.",
      );
    });
    return res;
  }

  Future<bool> isEmailExist(String? email) async {
    var query =
        await _personalInfoRef.where("email", isEqualTo: email).limit(1).get();
    return query.size > 0;
  }
}
