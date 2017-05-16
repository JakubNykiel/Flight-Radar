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
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
        
    }
}
extension FlightsMap: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let _ = getBoundsFromMap(map: mapView)
    }
    
    func getBoundsFromMap(map: GMSMapView) -> [String:CLLocationCoordinate2D]{
        var boundPoints: [String:CLLocationCoordinate2D] = [:]
        let visibleRegion: GMSVisibleRegion = map.projection.visibleRegion()
        let bounds: GMSCoordinateBounds = GMSCoordinateBounds.init(region: visibleRegion)
        
        boundPoints["northEast"] = bounds.northEast
        boundPoints["southWest"] = bounds.southWest
        print("NE:  lat:\(bounds.northEast.latitude) lon:\(bounds.northEast.longitude)")
        return boundPoints
    }
}
