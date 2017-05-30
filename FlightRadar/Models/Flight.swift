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
    case Trak = "Trak"
    case From = "From"
    case To = "To"
    case Airlines = "Op"
    case GroundSpeed = "Spd"
    case Altitude = "Alt"
}

class Flight {
    
    let lat: Float
    let lng: Float
    let model: String
    let call: String
    let trak: Double
    let from: String
    let destination: String
    let airlines: String
    let groundSpeed: Int
    let altitude: Int
    
    init(json: JSON) {
        self.lat = json[FlightFields.Latitude.rawValue].floatValue
        self.lng = json[FlightFields.Longitude.rawValue].floatValue
        self.model = json[FlightFields.Model.rawValue].stringValue
        self.call = json[FlightFields.Call.rawValue].stringValue
        self.trak = json[FlightFields.Trak.rawValue].doubleValue
        self.from = json[FlightFields.From.rawValue].stringValue
        self.destination = json[FlightFields.To.rawValue].stringValue
        self.airlines = json[FlightFields.Airlines.rawValue].stringValue
        self.groundSpeed = json[FlightFields.GroundSpeed.rawValue].intValue
        self.altitude = json[FlightFields.Altitude.rawValue].intValue
    }
}
/*
 *
 *  API functions
 *
 */

extension Flight {
    class func getPath(bound: GMSCoordinateBounds) -> String {
        
        let neLat = bound.northEast.latitude + 0.2
        let swLat = bound.southWest.latitude + 0.2
        let neLng = bound.northEast.longitude + 0.5
        let swLng = bound.southWest.longitude + 0.5
        
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
//                    completion([Flight]())
                    
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
