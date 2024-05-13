import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:login_alternativo/componentes/bottom_navigation_bar.dart';

//Guia de implementacion de
// https://fredrick-m.medium.com/google-places-api-with-flutter-ebac822a7546

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  int _currentIndex = 3;
  LatLng _center = LatLng(41.389262, 2.168451);
  List<Widget> citasWidgets = [];
  List<PlacesSearchResult> _placesList = [];
  final _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyBf7dMajiznsKDFN2nQOmb4Hq5MCYskYfA');

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _updateMapPosition(position);

      citasWidgets.clear();
      citasWidgets.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            tiltGesturesEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
        ),
      );
      _searchNearbyPlaces("Farmacia", _center);
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _searchNearbyPlaces(String query, LatLng location) async {
    try {
      final result = await _places.searchNearbyWithRadius(
        Location(lat: location.latitude, lng: location.longitude),
        5000,
        type: "pharmacy",
        keyword: query,
      );
      if (result.status == "OK") {
        setState(() {
          _placesList = result.results;
        });
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      print("Error searching nearby places: $e");
    }
  }

  void _updateMapPosition(Position position) {
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Farmacias cercanas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      // Muestra los widgets almacenados en la lista
      body: Stack(
        children: citasWidgets,
      ),
      
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          NavigationHandler navigationHandler = NavigationHandler(context);
          navigationHandler.handleNavigation(index);
        },
      ),
    );
  }
}
