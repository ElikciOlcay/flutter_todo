import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Location {
  double lat;
  double long;
  String location;

  Future<void> setCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      lat = position.latitude;
      long = position.longitude;
      await setLocationName();
    } catch (e) {
      print(e);
    }
  }

  Future setLocationName() async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    location = first.addressLine;
  }
}
