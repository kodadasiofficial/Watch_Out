import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/models/User.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';

class PersonalInfos {
  final CollectionReference _personalInfoRef =
      FirebaseFirestore.instance.collection("personal_info");

  Future<Map<String, dynamic>?> getCurrentPersonalInfos(
      BuildContext context) async {
    var user = AuthService().getCurrentUser();
    var data;
    if (user != null) {
      await _personalInfoRef
          .where("email", isEqualTo: user.email)
          .limit(1)
          .get()
          .then(
        (value) {
          data = value.docs[0].data();
        },
        onError: (e) => CustomSnackBar.showSnackBar(
          context,
          "An error occur while your report save",
        ),
      );
    }
    return data;
  }

  Future<bool> savePersonalInfos(
    BuildContext context,
    String? name,
    String? email,
  ) async {
    bool res = true;
    DateTime now = DateTime.now();
    String id = _personalInfoRef.doc().id;
    User saveUser = User(
        id: id,
        email: email ?? "",
        name: name ?? "",
        createdAt: now,
        modifiedAt: now);
    await _personalInfoRef.doc(id).set(saveUser.toMap()).catchError((error) {
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
