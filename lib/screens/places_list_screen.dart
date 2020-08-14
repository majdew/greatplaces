import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/places.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Great Places"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? CircularProgressIndicator()
            : Consumer<Places>(
                child: Center(
                  child: const Text("Got no Places Yet , start adding some!"),
                ),
                builder: (context, placesData, child) =>
                    placesData.places.length <= 0
                        ? child
                        : ListView.builder(
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(placesData.places[index].image),
                              ),
                              title: Text(placesData.places[index].title),
                              onTap: () {},
                            ),
                            itemCount: placesData.places.length,
                          ),
              ),
      ),
    );
  }
}
