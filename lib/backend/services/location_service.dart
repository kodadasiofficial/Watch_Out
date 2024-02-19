import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  Future<LatLng?> getLocation() async {
    loc.Location location = loc.Location();
    bool serviceState = await location.serviceEnabled();
    loc.LocationData locationData;
    LatLng? locationCoor;
    if (!serviceState) {
      try {
        serviceState = await location.requestService();
      } catch (e) {
        locationCoor = const LatLng(39.92500587721513, 32.83693213015795);
      }
    }
    if (serviceState) {
      loc.PermissionStatus permissionState = await location.hasPermission();
      if (permissionState == loc.PermissionStatus.denied) {
        try {
          permissionState = await location.requestPermission();
        } catch (e) {}
      }
      if (permissionState == loc.PermissionStatus.granted ||
          permissionState == loc.PermissionStatus.grantedLimited) {
        locationData = await location.getLocation();
        locationCoor = LatLng(locationData.latitude!.toDouble(),
            locationData.longitude!.toDouble());
      }
    }
    return locationCoor;
  }
}
