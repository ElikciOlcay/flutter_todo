import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:todoey/models/location.dart';

class LocationService {
  double _lat;
  double _long;
  Location _location;

  Future<Location> get getCurrentLocation async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      _lat = position.latitude;
      _long = position.longitude;
      final coordinates = new Coordinates(_lat, _long);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      _location =
          new Location(location: first.addressLine, lat: _lat, long: _long);
      return _location;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
