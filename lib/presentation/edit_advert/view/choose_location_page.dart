import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/presentation/edit_advert/bloc/edit_advert_bloc.dart';
import 'package:outsource/presentation/new_order/bloc/new_order_bloc.dart';
import 'package:outsource/resources/app_colors.dart';

class EditMapSample extends StatefulWidget {
  final EditAdvertBloc bloc;
  const EditMapSample({Key? key, required this.bloc}) : super(key: key);

  @override
  State<EditMapSample> createState() => MapSampleState();
}

class MapSampleState extends State<EditMapSample> {
  late GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  List<Placemark> placeMarks = [];
  double lat = 0;
  double long = 0;

  bool isLoading = false;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied forever');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    getLatLong();
  }

  Future<void> getLatLong() async {
    await getCurrentLocation().then((value) async {
      print(value);
      lat = value.latitude;
      long = value.longitude;
      widget.bloc.data.lat = value.latitude;
      widget.bloc.data.lon = value.longitude;
      print('$lat\n$long');
      Dio dio = Dio();
      // final response = await dio.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyCaF8kSudt2gbyGU1uVSm6Ch4q7OVGFqeM');
      // print("FUcK" + '$response');
      placeMarks = await placemarkFromCoordinates(
        lat,
        long,
        localeIdentifier: '${await LangRepository.getInstance().getLang()}',
      );
      print(placeMarks[0]);
      print(placeMarks);

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, long), 18),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _addMarker(LatLng(lat, long), "origin", BitmapDescriptor.defaultMarker);
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбрать локацию'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                // here save the value
                mapController = controller;
              },
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.3775, 64.5853),
                zoom: 16,
              ),
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              markers: Set<Marker>.of(markers.values),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(
                        context,
                        '${placeMarks[0].locality}, ${placeMarks[0].subLocality}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: const Text('Готово'),
                  ),
                  if (placeMarks.isNotEmpty)
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.green500,
                      ),
                      child: Text(
                        '${placeMarks[0].locality}, ${placeMarks[0].subLocality}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getLatLong,
        backgroundColor: AppColors.green500,
        label: const Text('Найти местоположение'),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
