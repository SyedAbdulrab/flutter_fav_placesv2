import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'fancy_loader.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key, required this.onPickLocation}) : super(key: key);
  final void Function(String location) onPickLocation;
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Position? _currentPosition;
  String? location;
  bool _isGettingLocation = false;

  Future<String> getHumanReadableLocation(latitude, longitude) async {
    setState(() {
      _isGettingLocation = true;
    });

    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks[0];

      String placeName = placemark.name ?? '';
      String locality = placemark.locality ?? '';
      String administrativeArea = placemark.administrativeArea ?? '';
      String country = placemark.country ?? '';
      String sublocality = placemark.subLocality ?? '';

      String formattedAddress = "$placeName, $sublocality, $locality, $administrativeArea, $country";
      setState(() {
        location = formattedAddress;
        _isGettingLocation = false;
      });

      widget.onPickLocation(formattedAddress);
      return formattedAddress;
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isGettingLocation = false;
      });
      return 'error bro';
    }
  }


  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      await getHumanReadableLocation(position.latitude, position.longitude);
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isGettingLocation = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (_isGettingLocation) {
      if (_isGettingLocation) {
        previewContent = const FancyLoadingIndicator();
      }    } else if (_currentPosition != null) {
      previewContent = Text(
        location ?? '',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
    }


    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {

              },
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
