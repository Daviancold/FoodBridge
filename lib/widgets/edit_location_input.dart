import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../models/listing.dart';

class EditLocationInput extends StatefulWidget {
  const EditLocationInput({super.key, required this.chosenLocation, required this.listing});

  final Listing listing;
  final void Function(UserLocation location) chosenLocation;

  @override
  State<EditLocationInput> createState() => _EditLocationInputState();
}

class _EditLocationInputState extends State<EditLocationInput> {
  UserLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get newLocationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyBPnh4TzaS8FEO7vnHEdobC0Z6hsJATCoE';
  }

  String get oldLocationImage {
    final oldLat = widget.listing.lat;
    final oldLng = widget.listing.lng;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$oldLat,$oldLng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$oldLat,$oldLng&key=AIzaSyBPnh4TzaS8FEO7vnHEdobC0Z6hsJATCoE';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    } //TODO add error handling

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyBPnh4TzaS8FEO7vnHEdobC0Z6hsJATCoE');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = UserLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
      widget.chosenLocation(_pickedLocation!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent;

    if (_pickedLocation != null) {
      previewContent = Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                newLocationImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withAlpha(0),
                  Colors.black12,
                  Colors.black45
                ],
              ),
            ),
            child: Text(
              _pickedLocation!.address,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ],
      );
    } else {
      previewContent = Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                oldLocationImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withAlpha(0),
                  Colors.black12,
                  Colors.black45
                ],
              ),
            ),
            child: Text(
              widget.listing.address,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ],
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(8)),
          child: previewContent,
        ),
        TextButton.icon(
          onPressed: _getCurrentLocation,
          icon: const Icon(Icons.map),
          label: const Text('Get location'),
        ),
      ],
    );
  }
}