import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LatLng location;
  final EdgeInsetsGeometry padding;
  final double height;
  CustomMap({
    super.key,
    required this.location,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
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
            target: location,
            zoom: 12,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
