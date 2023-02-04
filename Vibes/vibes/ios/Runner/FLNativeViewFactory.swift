//
//  FLNativeViewFactory.swift
//  Runner
//
//  Created by Luc Lawford on 04/02/2023.
//

import Foundation
import Flutter
import UIKit
import GoogleMaps

struct Pair<T, U> {
    let first: T
    let second: U
}

extension Pair: Equatable where T: Hashable, U: Hashable {}
extension Pair: Hashable where T: Hashable, U: Hashable {}

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var _view: FLNativeView?

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        _view = FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
        return _view!
    }
    func centreMap(showLocation: Bool, centre: Bool) {
        if _view != nil {
            _view!.centreMap(showLocation: showLocation, centre: centre)
        }
    }
}

class FLNativeView: NSObject, FlutterPlatformView, CLLocationManagerDelegate, GMSMapViewDelegate {
    private var mapView: GMSMapView
    private var zoomLevel: Float = 12
    private var timer: Timer? = nil

    static let colours = [UIColor(red: 254.0/255, green: 240.0/255, blue: 1.0/255, alpha: 1.0),
        UIColor(red: 255.0/255, green: 206.0/255, blue: 3.0/255, alpha: 1.0),
        UIColor(red: 253.0/255, green: 154.0/255, blue: 1.0/255, alpha: 1.0),
        UIColor(red: 253.0/255, green: 97.0/255, blue: 4.0/255, alpha: 1.0),
        UIColor(red: 255.0/255, green: 44.0/255, blue: 5.0/255, alpha: 1.0),
        UIColor(red: 240.0/255, green: 5.0/255, blue: 5.0/255, alpha: 1.0)]

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        
        let camera = GMSCameraPosition(latitude: 24.8607, longitude: 67.0011, zoom: 12)
        mapView = GMSMapView(frame: .zero, camera: camera)
        
        super.init()

        mapView.delegate = self
        
        setUpMapStyle()
        
        centreMap(showLocation: true, centre: true)
        mapView.setMinZoom(kGMSMinZoomLevel, maxZoom: 15.0)
    }

    func view() -> UIView {
        return mapView
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (mapView.camera.zoom == zoomLevel) {return}
        zoomLevel = mapView.camera.zoom
    }

    func mapView(_ mapView: GMSMapView, didChange cameraPosition: GMSCameraPosition) {
        if (mapView.camera.zoom == zoomLevel) {return}
        zoomLevel = mapView.camera.zoom
    }

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        if (mapView.camera.zoom == zoomLevel) {return}
        zoomLevel = mapView.camera.zoom
    }

    func centreMap(showLocation: Bool, centre: Bool) {
        //Location manager
        let locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        //Gets the users location
        let userLocation: CLLocationCoordinate2D? = locationManager.location?.coordinate

        if (centre) {
            let userLocPos = GMSCameraPosition.camera(
                withLatitude: userLocation?.latitude ?? 51.5072,
                longitude: userLocation?.longitude ?? -0.1276,
            zoom: 12
            )
            mapView.camera = userLocPos
            zoomLevel = mapView.camera.zoom
        }

        //Adds the user location to the map
        mapView.isMyLocationEnabled = showLocation
    }

    private func setUpMapStyle() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}

struct Location {
    var latitude: Double
    var longitude: Double
}

extension Location: Equatable {}
extension Location: Hashable {}

