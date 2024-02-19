import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/backend/services/location_service.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/ui/widgets/custom_map.dart';
import 'package:watch_out/ui/widgets/near_report_card.dart';

class HomePage extends StatefulWidget {
  final GlobalKey navigationBarKey;
  const HomePage({super.key, required this.navigationBarKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return locationEnabledWidget(snapshot.data![0], snapshot.data![1]);
          } else {
            return locationDisabledWidget();
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Palette.mainPage,
            body: const Center(
              child: Text("Something went wrong. Please try again"),
            ),
          );
        } else {
          return Container(
            color: Palette.mainPage,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Palette.lightGreen,
            ),
          );
        }
      },
    );
  }

  Future<List> getInfos() async {
    List snapshot = [];
    LatLng? location = await LocationService().getLocation();
    snapshot.add(location);
    List reports = await ReportsService().getAllReports(false);
    snapshot.add(reports);
    return snapshot;
  }

  Widget locationEnabledWidget(LatLng location, List reports) {
    BottomNavigationBar navigationBar =
        widget.navigationBarKey.currentWidget as BottomNavigationBar;
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            text("Map", "View More", () => navigationBar.onTap!(1)),
            CustomMap(
              location: location,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width - 50,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.3, 1.0],
                  colors: [
                    Palette.buttonBlue,
                    Palette.buttonGreen,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => navigationBar.onTap!(2),
                child: Text(
                  "Create a report",
                  style: TextStyle(
                    fontSize: Font.createAccountFontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            text("Near Reports", "View More", () => navigationBar.onTap!(3)),
            Row(
              children: [
                NearReportCard(data: reports[0].data()),
                NearReportCard(data: reports[1].data()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            text("Closest Safe Zone", "Go This Zone", () {}),
            CustomMap(
              location: location,
              height: 150,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
                top: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationDisabledWidget() {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: const Center(
        child: Text("Please give location permission to add report"),
      ),
    );
  }

  Widget text(String text1, String text2, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          RichText(
            text: TextSpan(
              text: text2,
              style: TextStyle(
                color: Palette.darkGreen,
                fontSize: Font.reportsFontSize,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
