import 'package:http/http.dart' as http;
import 'package:google_directions_api/google_directions_api.dart';

var origin = 'New York';
var destination = 'San Francisco';

void main() {
  DirectionsService.init("AIzaSyAfeJFnETcONatUhLKHaUJvzhSdnJU0X04");

  final directionsService = DirectionsService();

  final request = DirectionsRequest(
    travelMode: TravelMode.driving,
  );

  directionsService.route(request,
      (DirectionsResult response, DirectionsStatus status) {
    if (status == DirectionsStatus.ok) {
        System.out.println(response);
      // do something with successful response
    } else {
      // do something with error response
    }
  });
}