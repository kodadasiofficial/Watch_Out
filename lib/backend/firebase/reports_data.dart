import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_out/backend/firebase/personal_infos.dart';
import 'package:watch_out/backend/services/location_service.dart';
import 'package:watch_out/models/report.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';

class ReportsService {
  final CollectionReference _reportRef =
      FirebaseFirestore.instance.collection("reports");

  Future<bool> addReport(
    BuildContext context,
    LatLng location,
    String reportType,
    String report,
    String? reportHead,
    String? description,
  ) async {
    bool res = true;
    Map<String, dynamic>? curUser =
        await PersonalInfos().getCurrentPersonalInfos(context);
    String id = _reportRef.doc().id;
    if (curUser != null) {
      DateTime now = DateTime.now();
      Report curReport = Report(
        id: id,
        latitude: location.latitude,
        longitude: location.longitude,
        reporterName: curUser["name"].toString(),
        reporterProfilePhoto: curUser["profile_photo_url"].toString(),
        reportType: reportType,
        report: report,
        reportHead: reportHead ?? "",
        description: description ?? "",
        like: 0,
        dislike: 0,
        createdAt: now,
        modifiedAt: now,
      );
      await _reportRef.doc(id).set(curReport.toMap()).catchError(
        (error) {
          res = false;
          CustomSnackBar.showSnackBar(
            context,
            "Something went wrong. Please try again.",
          );
        },
      );
    } else {
      res = false;
      CustomSnackBar.showSnackBar(
          context, "Something went wrong. Please try again.");
    }
    return res;
  }

  Future<List> getAllReports(bool latest, {bool isLimited = false}) async {
    LatLng? location = await LocationService().getLocation();
    if (latest) {
      try {
        var snapshot =
            await _reportRef.orderBy("created_at", descending: true).get();
        if (location != null && isLimited) {
          return controlKm(snapshot.docs, location);
        }
        return snapshot.docs;
      } catch (e) {
        throw Error();
      }
    } else {
      try {
        if (location == null) {
          throw Error();
        } else {
          var snapshot =
              await _reportRef.orderBy("created_at", descending: true).get();
          List docs;
          if (isLimited) {
            docs = controlKm(snapshot.docs, location);
          } else {
            docs = snapshot.docs;
          }
          docs.sort((a, b) {
            double distanceA = Geolocator.distanceBetween(
                a.data()["latitude"].toDouble(),
                a.data()["longitude"].toDouble(),
                location.latitude,
                location.longitude);
            double distanceB = Geolocator.distanceBetween(
                b.data()["latitude"].toDouble(),
                b.data()["longitude"].toDouble(),
                location.latitude,
                location.longitude);
            return distanceA.compareTo(distanceB);
          });
          return docs;
        }
      } catch (e) {
        throw Error();
      }
    }
  }

  List controlKm(List docs, LatLng location) {
    List newDocs = [];
    for (dynamic i in docs) {
      Report report = Report.fromMap(i.data());
      double distance = Geolocator.distanceBetween(location.latitude,
          location.longitude, report.latitude, report.longitude);
      if (distance < 3000) {
        newDocs.add(i);
      }
    }
    return newDocs;
  }

  Future<void> updateLike(
    BuildContext context,
    String id,
    int like,
    String email,
    bool isAdd,
  ) async {
    try {
      await _reportRef.doc(id).update({"like": like});
      if (isAdd) {
        await addReportLiker(context, id, email);
      } else {
        await deleteReportLiker(context, id, email);
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Your approve for report cannot saved");
    }
  }

  Future<void> updateDislike(BuildContext context, String id, int dislike,
      String email, bool isAdd) async {
    try {
      await _reportRef.doc(id).update({"dislike": dislike});
      if (isAdd) {
        await addReportDisliker(context, id, email);
      } else {
        await deleteReportDisliker(context, id, email);
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Your disapprove for report cannot saved");
    }
  }

  Future<bool> controlLiked(String reportId, String email) async {
    List reports = await getReportLikers(reportId);
    for (dynamic i in reports) {
      if (i.data()["email"] == email) {
        return true;
      }
    }
    return false;
  }

  Future<bool> controlDisliked(String reportId, String email) async {
    List reports = await getReportDislikers(reportId);
    for (dynamic i in reports) {
      if (i.data()["email"] == email) {
        return true;
      }
    }
    return false;
  }

  Future<List> getReportLikers(String reportId) async {
    try {
      var snapshot = await _reportRef.doc(reportId).collection("likers").get();
      return snapshot.docs;
    } catch (e) {
      throw Error();
    }
  }

  Future<List> getReportDislikers(String reportId) async {
    try {
      var snapshot =
          await _reportRef.doc(reportId).collection("dislikers").get();
      return snapshot.docs;
    } catch (e) {
      throw Error();
    }
  }

  Future<void> addReportLiker(
      BuildContext context, String reportId, String email) async {
    String newId = _reportRef.doc(reportId).collection("likers").doc().id;

    await _reportRef.doc(reportId).collection("likers").doc(newId).set({
      "id": newId,
      "email": email,
    }).catchError(
      (e) => CustomSnackBar.showSnackBar(
          context, "Your approve for report cannot saved"),
    );
  }

  Future<void> addReportDisliker(
      BuildContext context, String reportId, String email) async {
    String newId = _reportRef.doc(reportId).collection("dislikers").doc().id;

    await _reportRef.doc(reportId).collection("dislikers").doc(newId).set({
      "id": newId,
      "email": email,
    }).catchError(
      (e) => CustomSnackBar.showSnackBar(
          context, "Your disapprove for report cannot saved"),
    );
  }

  Future<void> deleteReportLiker(
      BuildContext context, String reportId, String email) async {
    var snapshot = await _reportRef
        .doc(reportId)
        .collection("likers")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
    await snapshot.docs[0].reference.delete().catchError(
          (e) => CustomSnackBar.showSnackBar(
              context, "Your approve cannot be removed"),
        );
  }

  Future<void> deleteReportDisliker(
      BuildContext context, String reportId, String email) async {
    var snapshot = await _reportRef
        .doc(reportId)
        .collection("dislikers")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    await snapshot.docs[0].reference.delete().catchError(
          (e) => CustomSnackBar.showSnackBar(
              context, "Your disapprove cannot be removed"),
        );
  }
}
