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
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var groundSpeedLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    var allMarkersOnMap: [String:GMSMarker] = [:]
    var allPlanesInRegion: [String:Flight] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        flightDetailsView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.delegate = self
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getFlightsForPosition), userInfo: nil, repeats: true)
        
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
        getFlightsForPosition()
    }
    
    func getFlightsForPosition()
    {
        let myBounds = getBoundsFromMap(map: mapView)
        Flight.getFlights(bound: myBounds) { (allFlights: [Flight]) in
            for flight in allFlights
            {
                
                self.addPlaneToMap(lat: flight.lat, long: flight.lng, title: flight.call, trak: flight.trak)
                self.allPlanesInRegion[flight.call] = flight
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        flightDetailsView.setView(hidden: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        flightDetailsView.setView(hidden: false)
        return true
    }
    
    func getBoundsFromMap(map: GMSMapView) -> GMSCoordinateBounds{
        var boundPoints: [String:CLLocationCoordinate2D] = [:]
        let visibleRegion: GMSVisibleRegion = map.projection.visibleRegion()
        let bounds: GMSCoordinateBounds = GMSCoordinateBounds.init(region: visibleRegion)
        
        return bounds
    }
    
    func addPlaneToMap(lat: Float, long: Float, title: String, trak: Double)
    {
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        if allMarkersOnMap[title] != nil {
            allMarkersOnMap[title]?.position = position
        }
        else {
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "plane.png")
            marker.rotation = trak
            marker.title = title
            marker.map = mapView
            allMarkersOnMap[title] = marker
        }
    }
}
