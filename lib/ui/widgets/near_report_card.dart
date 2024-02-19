import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/models/report.dart';

class NearReportCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const NearReportCard({super.key, required this.data});

  @override
  State<NearReportCard> createState() => _NearReportCardState();
}

class _NearReportCardState extends State<NearReportCard> {
  late Report report;
  late int like;
  late int dislike;
  bool likeState = false;
  bool dislikeState = false;

  @override
  void initState() {
    report = Report.fromMap(widget.data);
    like = report.like;
    dislike = report.dislike;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.reportHead,
                  style: TextStyle(
                    fontSize: Font.loginFontSize,
                    color: Palette.mainPageTitle,
                  ),
                ),
                Text(
                  report.reportType,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              dateFormat.format(report.createdAt),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (!likeState) {
                      ReportsService().updateLike(context, report.id, like + 1);
                      setState(() {
                        like += 1;
                        likeState = true;
                        dislikeState = false;
                      });
                    } else {
                      ReportsService().updateLike(context, report.id, like - 1);
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
                  onPressed: () {
                    if (!dislikeState) {
                      ReportsService()
                          .updateDislike(context, report.id, dislike + 1);
                      setState(() {
                        dislike += 1;
                        likeState = false;
                        dislikeState = true;
                      });
                    } else {
                      ReportsService()
                          .updateDislike(context, report.id, dislike - 1);
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
            ),
          ],
        ),
      ),
    );
  }
}
