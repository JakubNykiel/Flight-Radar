//
//  Flight.swift
//  FlightRadar
//
//  Created by Jakub Nykiel on 16.05.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

enum FlightApi:String
{
    case allFlightsForCoordinate
}

class Flight {
    
    let lat: String?
    let lng: String?
    
    init(json: JSON) {
        self.lat = ""
        self.lng = ""
    }
}
/*
*
*  API functions
*
*/

extension Flight {
    class func getPath(bound: [String:CLLocationCoordinate2D]) -> String {
        let neLat = String(describing: bound["northEast"]?.latitude)
        let swLat = String(describing: bound["southWest"]?.latitude)
        let neLng = String(describing: bound["northEast"]?.longitude)
        let swLng = String(describing: bound["southWest"]?.longitude)
        
        return "https://public-api.adsbexchange.com/VirtualRadar/AircraftList.json?lat=52.1772&lng=20.9623&fNBnd=\(neLat)&fSBnd=\(swLat)&fEBnd=\(neLng)&fWBnd=\(swLng)"
    }
}
