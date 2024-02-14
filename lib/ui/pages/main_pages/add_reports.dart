import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/ui/widgets/custom_dropdown.dart';
import 'package:watch_out/ui/widgets/custom_text_field.dart';
import 'package:location/location.dart' as loc;

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: FutureBuilder(
        future: getLocation(),
        builder: (context, snapshot) => !snapshot.hasData
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Palette.lightGreen,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Palette.mainPage,
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 20,
                            top: 20,
                            bottom: 5,
                          ),
                          child: Text(
                            "Report Zone",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Font.reportsFontSize,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width - 20,
                            child: GoogleMap(
                              compassEnabled: false,
                              mapToolbarEnabled: false,
                              rotateGesturesEnabled: false,
                              scrollGesturesEnabled: false,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: false,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: snapshot.requireData,
                                zoom: 14.4746,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Text(
                            "Select Report Type",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Font.reportsFontSize,
                            ),
                          ),
                        ),
                        const CustomDropdown(
                          items: ["Danger Zone", "Aid Zone"],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Text(
                            "Select Report",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Font.reportsFontSize,
                            ),
                          ),
                        ),
                        const CustomDropdown(
                          items: [
                            "Shelling",
                            "Riffle Gun",
                            "Radioactive Material",
                            "Fire",
                            "Earthquake",
                            "Food",
                            "House",
                            "Water",
                            "Internet",
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            "Report Heading",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Font.reportsFontSize,
                            ),
                          ),
                        ),
                        const CustomTextField(
                          hinText: "Report Heading",
                          horPadd: 20,
                          vertPadd: 10,
                          borderRadius: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            "Report Description",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Font.reportsFontSize,
                            ),
                          ),
                        ),
                        const CustomTextField(
                          hinText: "Report Description",
                          horPadd: 20,
                          vertPadd: 10,
                          borderRadius: 10,
                          lineCount: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Palette.buttonGreen,
        child: const Text(
          "Post It",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<LatLng> getLocation() async {
    loc.Location location = loc.Location();
    bool serviceState = await location.serviceEnabled();
    loc.LocationData locationData;
    LatLng locationCoor;
    if (!serviceState) {
      try {
        serviceState = await location.requestService();
      } catch (e) {
        locationCoor = const LatLng(39.92500587721513, 32.83693213015795);
      }
    } //Uygulamaya ilk girişte servis izni verilmediyse buraya girilir.
    if (serviceState) {
      loc.PermissionStatus permissionState = await location.hasPermission();
      if (permissionState == loc.PermissionStatus.denied) {
        try {
          permissionState = await location.requestPermission();
        } catch (e) {
          locationCoor = const LatLng(39.929635, 32.8325187);
        }
      }
      if (permissionState == loc.PermissionStatus.granted ||
          permissionState == loc.PermissionStatus.grantedLimited) {
        locationData = await location.getLocation();
        locationCoor = LatLng(locationData.latitude!.toDouble(),
            locationData.longitude!.toDouble());
      } else if (permissionState == loc.PermissionStatus.deniedForever) {
        locationCoor = const LatLng(39.929635, 32.8325187);
      } else {
        locationCoor = const LatLng(39.929635, 32.8325187);
      }
    } else {
      locationCoor = const LatLng(39.929635, 32.8325187);
    }
    return locationCoor;
  }
}
