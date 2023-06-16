import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/api_key.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import '../../models/listing.dart';
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

  //Uses Google Places API to auto complete
  //searched addresses or postal codes
  Future<Prediction?> showGoogleAutoComplete() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      offset: 0,
      radius: 100,
      strictbounds: false,
      //Singapore region
      region: 'sg',
      context: context,
      apiKey: placesKey,
      mode: Mode.overlay,
      //language = engilsh
      language: 'en',
      //types returned by search
      types: [
        "neighborhood",
        "postal_code",
        "street_address"
      ], 
      hint: "Search address or postal code", // Update the hint text
      //limited to singapore
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

    //Check if location is turned on
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //check if permission is given
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

    //retrieve location using google maps API
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

   //The given code snippet creates a URL for making a request to the Google Geocoding API.
   //It includes the latitude and longitude coordinates of a location and an API key for 
   //authentication. The Uri.parse() function converts the URL string into a Uri object, 
   //which can be used to interact with the API and extract information from the URL.
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googMapsKey');

    //an HTTP GET request is made to the specified URL using the http package. The response
    //from the request is obtained and its body is decoded from JSON format using the 
    //json.decode() function. The resulting data is then accessed to extract the formatted address 
    //of the location from the response.
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    //update state and update location parameters in parent widget
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

  //Extract location data from selected 'prediction'/ suggestion
  void _getLatLng(Prediction prediction) async {
    //an instance of the GoogleMapsPlaces class is created and assigned 
    //to the _places variable. The GoogleMapsPlaces class is part of
    // the google_maps_webservice package and is used for making requests 
    //to the Google Maps Places API. The apiKey parameter is provided to authenticate
    // the API requests using the specified API key.
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: placesKey);

    //a request is made to the Google Places API to retrieve detailed information
    //about a place using its unique place ID. The response is stored in the detail 
    //variable, which will contain the detailed information such as the place's
    // address, coordinates, and other relevant data.
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);

    double lat = detail.result.geometry!.location.lat;
    double lng = detail.result.geometry!.location.lng;
    String address = prediction.description!;

    //update state and update location parameters in parent widget
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
