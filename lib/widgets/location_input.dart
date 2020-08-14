import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;
  LocationInput(this.onSelectLocation);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showImagePreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      longitude: longitude,
      latitude: latitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await Location().getLocation();

      _showImagePreview(locationData.latitude, locationData.longitude);

      widget.onSelectLocation(locationData.latitude, locationData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _onSelectMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    _showImagePreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectLocation(
        selectedLocation.latitude, selectedLocation.longitude);

    if (selectedLocation == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  "No Location Chosen !",
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Loaction'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _onSelectMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
