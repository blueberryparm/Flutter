import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/dbhelper.dart';
import '../models/place.dart';
import 'place_dialog.dart';
import 'manage_places.dart';

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final CameraPosition position = CameraPosition(
    target: LatLng(41.9028, 12.4964),
    zoom: 12,
  );
  List<Marker> markers = [];
  DbHelper helper;

  @override
  void initState() {
    _getCurrentLocation()
        .then((pos) => addMarker(pos, 'currpos', 'You are here!'))
        .catchError((err) => print(err.toString()));
    super.initState();
    helper = DbHelper();
    helper.insertMockData();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Treasure Mapp'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => ManagePlaces(),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: position,
          markers: Set<Marker>.of(markers),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          int here = markers.indexWhere(
            (p) => p.markerId == MarkerId('currpos'),
          );
          Place place;
          if (here == -1)
            // the current position is not available
            place = Place(0, '', 0, 0, '');
          else {
            LatLng pos = markers[here].position;
            place = Place(0, '', pos.latitude, pos.longitude, '');
          }
          PlaceDialog dialog = PlaceDialog(place, true);
          showDialog(
            context: context,
            builder: (context) => dialog.buildAlert(context),
          );
        },
      ),
    );
  }

  // Retrieves the places from the database
  Future _getData() async {
    await helper.openDb();
    List<Place> _places = await helper.getPlaces();
    _places.forEach(
      (Place p) => addMarker(
        Position(latitude: p.lat, longitude: p.lon),
        p.id.toString(),
        p.name,
      ),
    );
    setState(() => markers = markers);
  }

  void addMarker(Position pos, String markerId, String markerTitle) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: markerTitle),
      icon: (markerId == 'currpos')
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    markers.add(marker);
    setState(() => markers = markers);
  }

  Future _getCurrentLocation() async {
    // Not all devices have geolocation. Check whether the functionality is
    // available or not before finding the current position
    bool isGeoLocationAvailable = await Geolocator.isLocationServiceEnabled();
    Position _position = Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
    );
    if (isGeoLocationAvailable)
      try {
        _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
      } catch (error) {
        return _position;
      }
    return _position;
  }
}
