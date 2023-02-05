import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_services_dart/googles_maps_services_dart.dart';
import 'package:vibes/.env.dart';
import 'package:vibes/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:usb_serial/usb_serial.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({required Dio dio}) : _dio = dio;

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      var timeAndManeuver = [];
      response.data['routes'][0]['legs'][0]['steps'].forEach((element) {
        var step = [element['duration']['value'], element['maneuver']];
        timeAndManeuver.add(step);
      });
      timeAndManeuver.removeWhere((value) => value[1] == null);
      timeAndManeuver = createInstrs(timeAndManeuver);

      print(timeAndManeuver);
      sendToArduino(timeAndManeuver);
      return Directions.fromMap(response.data);
    }
    return Directions(
      bounds: LatLngBounds(
        northeast: const LatLng(0, 0),
        southwest: const LatLng(0, 0),
      ),
      polylinePoints: const [],
      totalDistance: '',
      totalDuration: '',
    );
  }

  List<dynamic> createInstrs(List<dynamic> l) {
    l.forEach((element) {
      element[1] = getDirection(element[1]);
    });
    return l;
  }

  Direction getDirection(String s) {
    switch (s) {
      case 'turn-left':
      case 'turn-slight-left':
      case 'turn-sharp-left':
      case 'uturn-left':
        return Direction.L;
      case 'turn-right':
      case 'turn-slight-right':
      case 'turn-sharp-right':
      case 'uturn-right':
        return Direction.R;
      default:
        return Direction.S;
    }
  }

  //please write code to send my output array to the arduino
  //I think you can use the usb_serial package to do this but I'm not sure
  // here is the function:
  void sendToArduino(List<dynamic> l) async {
    Socket socket = await Socket.connect('185.69.144.133', 5000);
    socket.add(utf8.encode(json.encode(l)));
    await socket.flush();
    await socket.close();
  }
}

enum Direction { L, R, S }

class Instruction {
  final int time;
  final Direction direction;

  Instruction({required this.time, required this.direction});
}
