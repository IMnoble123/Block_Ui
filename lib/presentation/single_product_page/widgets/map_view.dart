import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../resources/color.dart';

class MapView extends StatefulWidget {
  const MapView({
    Key? key,
    required this.latLngList,
    this.title,
  }) : super(key: key);

  final List<LatLng?> latLngList;
  final String? title;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> markers = {};

  @override
  void initState() {
    print(widget.latLngList);
    for (var element in widget.latLngList) {
      if (element != null) {
        markers.add(Marker(
            markerId: MarkerId(
              "${element.latitude}${element.longitude}",
            ),
            position: LatLng(element.latitude, element.longitude)));
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return markers.isNotEmpty
        ? Container(
            color: AppColors.lightGrey,
            child: GoogleMap(
              markers: markers,
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                if (_bounds(markers) != null) {
                  controller.animateCamera(
                      CameraUpdate.newLatLngBounds(_bounds(markers)!, 140));
                }
              },
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: false,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: LatLng(0.1, 0.1), zoom: 1.0),
            ),
          )
        : const Center(
            child: Text("No Location Data Found"),
          );
  }

  LatLngBounds? _bounds(Set<Marker> markers) {
    if (markers.isEmpty) return null;
    return _createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }
}

//
// const Marker(
// markerId: MarkerId(
// "1",
// ),
// position: LatLng(21.040147585139174, 77.92915653517949)),
// const Marker(
// markerId: MarkerId(
// "2",
// ),
// position: LatLng(36.017279274187096, -85.1682531751334))
