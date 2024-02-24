import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/models/report.dart';
import 'package:watch_out/ui/widgets/report_widget.dart';

class NearestLatestPage extends StatefulWidget {
  final bool latest;
  const NearestLatestPage({super.key, this.latest = true});

  @override
  State<NearestLatestPage> createState() => _NearestLatestPageState();
}

class _NearestLatestPageState extends State<NearestLatestPage> {
  User? user = AuthService().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
                top: 30,
              ),
              child: ListView.builder(
                itemCount: snapshot.data!["reports"].length,
                itemBuilder: ((context, index) {
                  Report data =
                      Report.fromMap(snapshot.data!["reports"][index].data());
                  return ReportWidget(
                    report: data,
                    likeState: snapshot.data!["likeState"][index],
                    dislikeState: snapshot.data!["dislikeState"][index],
                  );
                }),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const Text("There is no report near your location"),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong. Please try again"),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Palette.lightGreen,
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> getInfos() async {
    Map<String, dynamic> res = {};
    var reports =
        await ReportsService().getAllReports(widget.latest, isLimited: true);
    List likeState = [];
    List dislikeState = [];
    for (dynamic i in reports) {
      likeState.add(
          await ReportsService().controlLiked(i.data()["id"], user!.email!));
      dislikeState.add(
          await ReportsService().controlDisliked(i.data()["id"], user!.email!));
    }
    res["reports"] = reports;
    res["likeState"] = likeState;
    res["dislikeState"] = dislikeState;
    return res;
  }
}
