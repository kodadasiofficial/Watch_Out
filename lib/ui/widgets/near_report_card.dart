import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/models/report.dart';

class NearReportCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool likeState;
  final bool dislikeState;
  const NearReportCard({
    super.key,
    required this.data,
    required this.likeState,
    required this.dislikeState,
  });

  @override
  State<NearReportCard> createState() => _NearReportCardState();
}

class _NearReportCardState extends State<NearReportCard> {
  late Report report;
  late int like;
  late int dislike;
  bool likeState = false;
  bool dislikeState = false;
  User? user = AuthService().getCurrentUser();

  @override
  void initState() {
    report = Report.fromMap(widget.data);
    like = report.like;
    dislike = report.dislike;
    likeState = widget.likeState;
    dislikeState = widget.dislikeState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Palette.lightGreen,
        ),
        width: (MediaQuery.of(context).size.width - 40) / 2,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report.reportHead,
                    style: TextStyle(
                      fontSize: 16,
                      color: Palette.mainPageTitle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    report.reportType,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              dateFormat.format(report.createdAt),
            ),
            user!.email != report.reporterMail
                ? Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (!likeState) {
                            ReportsService().updateLike(
                              context,
                              report.id,
                              like + 1,
                              user!.email!,
                              true,
                            );
                            if (dislikeState) {
                              ReportsService().updateDislike(
                                context,
                                report.id,
                                dislike - 1,
                                user!.email!,
                                false,
                              );
                              dislike -= 1;
                              dislikeState = false;
                            }
                            setState(() {
                              like += 1;
                              likeState = true;
                            });
                          } else {
                            ReportsService().updateLike(
                              context,
                              report.id,
                              like - 1,
                              user!.email!,
                              false,
                            );
                            setState(() {
                              like -= 1;
                              likeState = false;
                            });
                          }
                        },
                        icon: likeState
                            ? const Icon(Icons.thumb_up_alt)
                            : const Icon(Icons.thumb_up_alt_outlined),
                      ),
                      Text(like.toString()),
                      IconButton(
                        onPressed: () async {
                          if (!dislikeState) {
                            ReportsService().updateDislike(
                              context,
                              report.id,
                              dislike + 1,
                              user!.email!,
                              true,
                            );
                            if (likeState) {
                              ReportsService().updateLike(
                                context,
                                report.id,
                                like - 1,
                                user!.email!,
                                false,
                              );
                              like -= 1;
                              likeState = false;
                            }
                            setState(() {
                              dislike += 1;
                              dislikeState = true;
                            });
                          } else {
                            ReportsService().updateDislike(
                              context,
                              report.id,
                              dislike - 1,
                              user!.email!,
                              false,
                            );
                            setState(() {
                              dislike -= 1;
                              dislikeState = false;
                            });
                          }
                        },
                        icon: dislikeState
                            ? const Icon(Icons.thumb_down_alt)
                            : const Icon(Icons.thumb_down_alt_outlined),
                      ),
                      Text(dislike.toString()),
                    ],
                  )
                : Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: const Text("This is your report"),
                  ),
          ],
        ),
      ),
    );
  }
}
