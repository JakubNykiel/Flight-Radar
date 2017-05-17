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

enum FlightFields:String
{
    case Latitude = "Lat"
    case Longitude = "Long"
    case Model = "Mdl"
    case Call = "Call"
}

class Flight {
    
    let lat: Double
    let lng: Double
    let model: String
    let call: String
    
    init(json: JSON) {
        self.lat = json[FlightFields.Latitude.rawValue].doubleValue
        self.lng = json[FlightFields.Longitude.rawValue].doubleValue
        self.model = json[FlightFields.Model.rawValue].stringValue
        self.call = json[FlightFields.Call.rawValue].stringValue
    }
}
/*
 *
 *  API functions
 *
 */

extension Flight {
    class func getPath(bound: GMSCoordinateBounds) -> String {
        
        let neLat = bound.northEast.latitude
        let swLat = bound.southWest.latitude
        let neLng = bound.northEast.longitude
        let swLng = bound.southWest.longitude
        
        let path = "https://public-api.adsbexchange.com/VirtualRadar/AircraftList.json?fNBnd=\(neLat)&fSBnd=\(swLat)&fEBnd=\(neLng)&fWBnd=\(swLng)"
        print(path)
        return path
    }
    
    class func getFlights(bound: GMSCoordinateBounds, completion: @escaping (_ allFlights:[Flight]) -> Void) {
        Alamofire.request(Flight.getPath(bound: bound))
            .responseJSON { response in
                switch response.result {
                
                case .failure(let error):
                    print(error)
                    completion([Flight]())
                    
                case .success(let value):
                    let json = JSON(value)
                    var flights: [Flight] = []
                    for flight in json["acList"].arrayValue
                    {
                        flights.append(Flight(json: flight))
                    }
                    completion(flights)
                }
                
        }
    }
}
