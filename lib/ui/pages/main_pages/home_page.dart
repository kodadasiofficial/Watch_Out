import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/backend/services/location_service.dart';
import 'package:watch_out/backend/services/zone_services.dart';
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
  User? user = AuthService().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return locationEnabledWidget(
              snapshot.data!["location"],
              snapshot.data!["reports"],
              snapshot.data!["likeState"],
              snapshot.data!["dislikeState"],
              snapshot.data!["zones"],
            );
          } else {
            return locationDisabledWidget();
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Palette.mainPage,
            body: const Center(
              child: Text("Something went wrong. Please try again."),
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

  Future<Map<String, dynamic>> getInfos() async {
    Map<String, dynamic> snapshot = {};
    LatLng? location = await LocationService().getLocation();
    snapshot["location"] = location;
    List reports = await ReportsService().getAllReports(false, isLimited: true);
    snapshot["reports"] = reports;
    snapshot["zones"] = ZoneService().getZones(reports);
    List likeState = [];
    List dislikeState = [];
    for (dynamic i in reports) {
      likeState.add(
          await ReportsService().controlLiked(i.data()["id"], user!.email!));
      dislikeState.add(
          await ReportsService().controlDisliked(i.data()["id"], user!.email!));
    }
    snapshot["likeState"] = likeState;
    snapshot["dislikeState"] = dislikeState;
    return snapshot;
  }

  Widget locationEnabledWidget(
    LatLng location,
    List reports,
    List likeStates,
    List dislikeStates,
    Set<Circle> zones,
  ) {
    BottomNavigationBar navigationBar =
        widget.navigationBarKey.currentWidget as BottomNavigationBar;
    Map<String, dynamic> closestSafeZone =
        ZoneService().findClosestSafeZone(location, zones);
    Set<Circle> showZones =
        zones.where((circle) => circle.circleId.value == "DangerZone").toSet();
    showZones.add(closestSafeZone["safeZone"]);
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
              enableTap: true,
              zones: zones,
              zoom: 14,
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
            reports.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) => NearReportCard(
                        data: reports[index].data(),
                        likeState: likeStates[index],
                        dislikeState: dislikeStates[index],
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text("There is no report near your location"),
                  ),
            const SizedBox(
              height: 10,
            ),
            text(
              "Closest Safe Zone",
              "Go This Zone",
              () => MapsLauncher.launchCoordinates(
                closestSafeZone["centerLocation"].latitude,
                closestSafeZone["centerLocation"].longitude,
              ),
            ),
            CustomMap(
              location: closestSafeZone["centerLocation"],
              height: 150,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
                top: 0,
              ),
              enableTap: true,
              zones: showZones,
              zoom: 14,
              safeZone: true,
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
