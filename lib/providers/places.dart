import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/database_helper.dart';
import '../helpers/location_helper.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace(String title, File pickedImage, PlaceLocation location) async {
    String address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);

    final updatedLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
      image: pickedImage,
    );
    _places.add(newPlace);
    notifyListeners();

    DatabaseHelper.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DatabaseHelper.getData('places');

    _places = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address']),
            image: File(item['image']),
          ),
        )
        .toList();

    notifyListeners();
  }

  Place findById(String id) {
    return _places.firstWhere((place) => place.id == id);
  }
}
