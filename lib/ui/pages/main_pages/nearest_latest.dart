import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReportsService().getAllReports(widget.latest),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 30,
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                Report data = Report.fromMap(snapshot.data![index].data());
                return ReportWidget(
                  report: data,
                );
              }),
            ),
          );
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
}
