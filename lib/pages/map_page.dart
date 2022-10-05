import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _centerLocation =
      const LatLng(-26.72315217804702, -53.538362142891906);
  late LatLng _currentLocation;

  Future _addMarker(LatLng latlng) async {
    setState(() {
      _currentLocation = latlng;
      final MarkerId markerId = MarkerId("IDMAPA");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position:
            latlng, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Meu local",
          snippet: 'Meu local',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers[markerId] = marker;
    });

    mapController.animateCamera(CameraUpdate.newLatLngZoom(latlng, 18.0));
  }

  void _closeMap() {
    Navigator.pop(context, 
    "${_currentLocation.latitude}, ${_currentLocation.longitude}");
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mapas - Endereço:'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.satellite,
            onLongPress: (latlng) => {_addMarker(latlng)},
            initialCameraPosition: CameraPosition(
              target: _centerLocation,
              zoom: 18.0,
            ),
            markers: Set<Marker>.of(markers.values)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _closeMap,
          label: Text("Fechar Mapa"),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
    );
  }
}
