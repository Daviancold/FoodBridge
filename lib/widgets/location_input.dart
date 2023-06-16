import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/api_key.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import '../models/listing.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.chosenLocation});

  final void Function(UserLocation? location) chosenLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Widget previewContent = const Text('Get location');
  UserLocation? _pickedLocation;
  var _isGettingLocation = false;

  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  //Use reverse geocoding to get snapshot image of map
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googMapsKey';
  }

  Future<Prediction?> showGoogleAutoComplete() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      offset: 0,
      radius: 100,
      strictbounds: false,
      region: 'sg',
      context: context,
      apiKey: placesKey,
      mode: Mode.overlay,
      language: 'en',
      types: [
        "neighborhood",
        "postal_code",
        "street_address"
      ], // Include "address" and "(regions)"
      hint: "Search address or postal code", // Update the hint text
      components: [Component(Component.country, 'sg')],
    );

    if (prediction == null) {
      return null;
    } else {
      return prediction;
    }
  }

  //Check for user permission to access location
  //Retrieves latitude and longitude of current location
  void _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
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
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googMapsKey');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = UserLocation(
        latitude: lat,
        longitude: lng,
        address: address,
        addressImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googMapsKey',
      );
      _isGettingLocation = false;
      _addressController.clear();
      _addressController.text = address;
      widget.chosenLocation(_pickedLocation!);
    });
  }

  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: placesKey);

    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);

    double lat = detail.result.geometry!.location.lat;
    double lng = detail.result.geometry!.location.lng;
    String address = prediction.description!;

    setState(() {
      _addressController.text = address;
      _pickedLocation = UserLocation(
        latitude: lat,
        longitude: lng,
        address: address,
        addressImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googMapsKey',
      );
      _isGettingLocation = false;
      widget.chosenLocation(_pickedLocation!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              locationImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
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
        TextField(
          readOnly: true,
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _pickedLocation = null;
                  previewContent =  const Text('Get location');
                  _addressController.clear();
                  widget.chosenLocation(_pickedLocation);
                });
              },
            ),
          ),
          onTap: () async {
            Prediction? prediction = await showGoogleAutoComplete();
            if (prediction != null) {
              _getLatLng(prediction);
            }
          },
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
