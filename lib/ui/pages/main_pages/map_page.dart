import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/backend/services/location_service.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/models/report.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Circle> zones = {};
  late Set<Circle> filteredZones = zones;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfos(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return mainPage(snapshot.data!);
          } else {
            return Scaffold(
              backgroundColor: Palette.mainPage,
              body: const Center(
                child: Text("Please give location permission to add report"),
              ),
            );
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
      }),
    );
  }

  Widget mainPage(LatLng location) {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 70,
                ),
                width: 400,
                height:
                    MediaQuery.of(context).size.height - kToolbarHeight - 200,
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  circles: (filteredZones),
                  markers: {
                    Marker(
                      markerId: const MarkerId("1"),
                      position: location,
                      icon: markerIcon,
                    )
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: SingleChildScrollView(
                        child: SearchLocation(
                          apiKey: "AIzaSyBXb31guuYTnJ9_lK3WbHkmsi5dTV7Rk3Q",
                          language: 'en',
                          onSelected: _goToTheSearch,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.filter_alt_sharp),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              title: const Text('All zones'),
                              onTap: () {
                                setState(() {
                                  filteredZones = zones;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Danger Zone'),
                              onTap: () {
                                setState(() {
                                  filteredZones = zones
                                      .where((circle) =>
                                          circle.circleId.value == "DangerZone")
                                      .toSet();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Old Danger Zone'),
                              onTap: () {
                                setState(() {
                                  filteredZones = zones
                                      .where((circle) =>
                                          circle.circleId.value ==
                                          "OldDangerZone")
                                      .toSet();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Aid Zone'),
                              onTap: () {
                                setState(() {
                                  filteredZones = zones
                                      .where((circle) =>
                                          circle.circleId.value == "AidZone")
                                      .toSet();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<LatLng?> getInfos() async {
    LatLng? location = await LocationService().getLocation();
    List<dynamic> reports = await ReportsService().getAllReports(true);
    for (dynamic i in reports) {
      Report report = Report.fromMap(i.data());
      int difference = DateTime.now().difference(report.createdAt).inHours;
      Color fillColor;
      String id;
      if (report.reportType == "Danger Zone") {
        if (difference > 12) {
          id = "OldDangerZone";
          fillColor = Colors.grey.withOpacity(0.5);
        } else {
          id = "DangerZone";
          fillColor = Colors.red.withOpacity(0.5);
        }
      } else {
        if (difference > 12) {
          continue;
        } else {
          id = "AidZone";
          fillColor = Colors.yellow.withOpacity(0.5);
        }
      }
      zones.add(
        Circle(
          circleId: CircleId(id),
          center: LatLng(report.latitude, report.longitude),
          radius: 420,
          strokeWidth: 2,
          fillColor: fillColor,
        ),
      );
    }
    return location;
  }

  Future<void> _goToTheSearch(Place place) async {
    final geolocation = await place.geolocation;

    // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(
        geolocation?.coordinates.latitude,
        geolocation?.coordinates.longitude)));
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(geolocation?.coordinates.latitude,
                geolocation?.coordinates.longitude),
            northeast: LatLng(geolocation?.coordinates.latitude,
                geolocation?.coordinates.longitude)),
        0));
  }
}
