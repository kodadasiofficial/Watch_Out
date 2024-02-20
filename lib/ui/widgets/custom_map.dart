import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LatLng location;
  final EdgeInsetsGeometry padding;
  final double height;
  final bool enableTap;
  final Set<Circle> zones;
  final double zoom;
  CustomMap({
    super.key,
    required this.location,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    this.height = 200,
    this.enableTap = false,
    this.zones = const {},
    this.zoom = 12,
  });
  final BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width - 20,
        child: GoogleMap(
          compassEnabled: false,
          mapToolbarEnabled: enableTap,
          rotateGesturesEnabled: enableTap,
          scrollGesturesEnabled: enableTap,
          myLocationButtonEnabled: enableTap,
          zoomControlsEnabled: enableTap,
          zoomGesturesEnabled: enableTap,
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: zoom,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          circles: zones,
          markers: {
            Marker(
              markerId: const MarkerId("1"),
              position: location,
              icon: markerIcon,
            )
          },
        ),
      ),
    );
  }
}
