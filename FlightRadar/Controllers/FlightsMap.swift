//
//  FlightsMap.swift
//  FlightRadar
//
//  Created by Jakub Nykiel on 16.05.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit
import GoogleMaps

class FlightsMap: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FlightsMap:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
        
    }
}
extension FlightsMap: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        let myBounds = getBoundsFromMap(map: mapView)
        Flight.getFlights(bound: myBounds) { (allFlights: [Flight]) in
            for flight in allFlights
            {
                self.addPlaneToMap(lat: flight.lat, long: flight.lng, title: flight.call, trak: flight.trak)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    func getBoundsFromMap(map: GMSMapView) -> GMSCoordinateBounds{
        var boundPoints: [String:CLLocationCoordinate2D] = [:]
        let visibleRegion: GMSVisibleRegion = map.projection.visibleRegion()
        let bounds: GMSCoordinateBounds = GMSCoordinateBounds.init(region: visibleRegion)
        
        return bounds
    }
    
    func addPlaneToMap(lat: Double, long: Double, title: String, trak: Double)
    {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "plane.png")
        marker.rotation = trak
        marker.title = title
        marker.map = mapView
    }
}
