import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_out/backend/services/location_service.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/backend/firebase/reports_data.dart';
import 'package:watch_out/ui/widgets/custom_dropdown.dart';
import 'package:watch_out/ui/widgets/custom_map.dart';
import 'package:watch_out/ui/widgets/custom_text_field.dart';
import 'package:watch_out/ui/widgets/snack_bar.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController reportType = TextEditingController();
  TextEditingController report = TextEditingController();
  TextEditingController reportHeadController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService().getLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return locationEnabledWidget(snapshot.data!);
          } else {
            return locationDisabledWidget();
          }
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

  Widget locationEnabledWidget(LatLng location) {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: SingleChildScrollView(
        child: Container(
          color: Palette.mainPage,
          child: Form(
            key: _formKey,
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
                CustomMap(
                  location: location,
                  zones: {
                    Circle(
                      circleId: const CircleId("Add Zone"),
                      center: location,
                      radius: 420,
                      strokeWidth: 2,
                      fillColor: Palette.mainPageTitle.withOpacity(0.5),
                    ),
                  },
                  zoom: 14,
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
                CustomDropdown(
                  items: const ["Danger Zone", "Aid Zone"],
                  controller: reportType,
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
                CustomDropdown(
                  items: const [
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
                  controller: report,
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
                CustomTextField(
                  hinText: "Report Heading",
                  horPadd: 20,
                  vertPadd: 10,
                  borderRadius: 10,
                  controller: reportHeadController,
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
                CustomTextField(
                  hinText: "Report Description",
                  horPadd: 20,
                  vertPadd: 10,
                  borderRadius: 10,
                  lineCount: 5,
                  controller: descriptionController,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => addReport(location),
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

  Widget locationDisabledWidget() {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: const Center(
        child: Text("Please give location permission to add report"),
      ),
    );
  }

  Future<void> addReport(LatLng location) async {
    bool res = await ReportsService().addReport(
      context,
      location,
      reportType.text,
      report.text,
      reportHeadController.text,
      descriptionController.text,
    );
    if (res) {
      CustomSnackBar.showSnackBar(context, "Your Report Added Succesfully");
      _formKey.currentState!.reset();
      reportType.text = "Danger Zone";
      report.text = "Shelling";
    }
  }
}
