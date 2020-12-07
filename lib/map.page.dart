
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
   String latitude;
   String longitude;

   MapPage(this.longitude, this.latitude);

  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Set<Marker> markers = new Set<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          onFieldSubmitted: (val){
            double lat = double.parse(widget.latitude);
            double long = double.parse(widget.longitude);

            LatLng position = LatLng(lat, long);
            mapController.moveCamera(CameraUpdate.newLatLng(position));

            final Marker marker = Marker(
              markerId:  new MarkerId("123456"),
              position: position,
              infoWindow: InfoWindow(
                title: "Casa",
                snippet: 'Goias',
              ),
            );
            setState(() {
              markers.add(marker);
            });

          },
        ),
      ),
      body: Container(
        child: GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (data){
            },
            onTap: (position){
            },
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
              zoom: 11.0,
            )),
      )
    );
  }
}
