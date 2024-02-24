import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/models/report.dart';

class ZoneService {
  Map<String, dynamic> findClosestSafeZone(LatLng location, Set<Circle> zones) {
    Set<Circle> dangerZones =
        zones.where((circle) => circle.circleId.value == "DangerZone").toSet();
    LatLng newLoc = location;
    while (true) {
      int counter = 0;
      for (Circle i in dangerZones) {
        double distance = Geolocator.distanceBetween(
          i.center.latitude,
          i.center.longitude,
          newLoc.latitude,
          newLoc.longitude,
        );
        if (distance < 300) {
          break;
        } else {
          counter++;
        }
      }
      if (counter == dangerZones.length) {
        Map<String, dynamic> res = {};
        if (location != newLoc) {
          newLoc = LatLng(newLoc.latitude + 0.003, newLoc.longitude + 0.003);
        }
        res["safeZone"] = Circle(
          circleId: const CircleId("Safe Zone"),
          center: newLoc,
          radius: 420,
          strokeWidth: 2,
          fillColor: Palette.lightGreen.withOpacity(0.5),
        );
        res["centerLocation"] = newLoc;
        return res;
      }
      newLoc = LatLng(newLoc.latitude + 0.001, newLoc.longitude + 0.001);
    }
  }

  Set<Circle> getZones(List<dynamic> reports) {
    Set<Circle> zones = {};
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
    return zones;
  }
}
