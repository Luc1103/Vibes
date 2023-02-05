import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_services_dart/googles_maps_services_dart.dart';
import 'package:vibes/.env.dart';
import 'package:vibes/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

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
        print(step);
      });
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
}
