import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/models/report.dart';
import 'package:watch_out/ui/widgets/custom_button.dart';

class ReportWidget extends StatefulWidget {
  final Report report;
  const ReportWidget({
    super.key,
    required this.report,
  });

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  late int like;
  late int dislike;
  bool likeState = false;
  bool dislikeState = false;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  @override
  void initState() {
    like = widget.report.like;
    dislike = widget.report.dislike;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height / 2) - 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Palette.lightGreen,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  child: widget.report.reporterProfilePhoto == ""
                      ? const Icon(Icons.person)
                      : Image.network(widget.report.reporterProfilePhoto),
                ),
                Text(
                  widget.report.reporterName,
                  style: TextStyle(
                    fontSize: Font.createAccountFontSize,
                    color: Palette.darkGreen,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 20,
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.report.reportHead,
                        style: TextStyle(
                          fontSize: Font.loginFontSize,
                          color: Palette.mainPageTitle,
                        ),
                      ),
                      Text(
                        widget.report.reportType,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(dateFormat.format(widget.report.createdAt)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (!likeState) {
                            ReportsService().updateLike(
                                context, widget.report.id, like + 1);
                            setState(() {
                              like += 1;
                              likeState = true;
                              dislikeState = false;
                            });
                          } else {
                            ReportsService().updateLike(
                                context, widget.report.id, like - 1);
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
                            ReportsService().updateDislike(
                                context, widget.report.id, dislike + 1);
                            setState(() {
                              dislike += 1;
                              likeState = false;
                              dislikeState = true;
                            });
                          } else {
                            ReportsService().updateDislike(
                                context, widget.report.id, dislike - 1);
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
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Palette.mainPage,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(widget.report.description),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onPressed: () => MapsLauncher.launchCoordinates(
                          widget.report.latitude,
                          widget.report.longitude,
                        ),
                        text: "View on map",
                        height: 1,
                        width: 120,
                        borderRadius: 30,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(top: 10),
                        textStyle: TextStyle(
                          color: Palette.darkGreen,
                          fontSize: 12,
                        ),
                        color: Palette.mainPage,
                      ),
                      IconButton(
                        onPressed: () {
                          String link;
                          if (Platform.isIOS) {
                            link =
                                'https://maps.apple.com/?sll=${widget.report.latitude},${widget.report.longitude}';
                          } else {
                            link =
                                "https://www.google.com/maps/search/?api=1&query=${widget.report.latitude},${widget.report.longitude}";
                          }
                          Share.share(
                            "There is an ${widget.report.reportType}. Be careful!. \n\nReport Head: ${widget.report.reportHead}\nReport Description: ${widget.report.description}\n\nYou can reach this zone with link below\n\n$link",
                            subject: "${widget.report.reportType} Report",
                          );
                        },
                        icon: Icon(
                          Icons.share,
                          color: Palette.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
