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
    class func getPath(bound: GMSCoordinateBounds) -> String {
        
        let neLat = bound.northEast.latitude
        let swLat = bound.southWest.latitude
        let neLng = bound.northEast.longitude
        let swLng = bound.southWest.longitude
        
        let path = "https://public-api.adsbexchange.com/VirtualRadar/AircraftList.json?fNBnd=\(neLat)&fSBnd=\(swLat)&fEBnd=\(neLng)&fWBnd=\(swLng)"
        print(path)
        return path
    }
    
    class func getFlights(bound: GMSCoordinateBounds, completion: @escaping ([Flight]) -> Void) {
        Alamofire.request(Flight.getPath(bound: bound))
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                   print("JSON: \(json)")
                case .failure(let error):
                    print(error)
                }
        }
//        
//                guard let responseJSON = response.result.value as? JSON,
//                    let results = responseJSON[0]["results"],
//                    let firstResult = results.first,
//                    let info = firstResult["info"] as? [String: Any],
//                    let imageColors = info["image_colors"] as? [[String: Any]] else {
//                        print("Invalid color information received from service")
//                        completion([Flight]())
//                        return
//                }
//                
//                let photoColors = imageColors.flatMap({ (dict) -> Flight? in
//                    guard let r = dict["r"] as? String,
//                        let g = dict["g"] as? String,
//                        let b = dict["b"] as? String,
//                        let closestPaletteColor = dict["closest_palette_color"] as? String else {
//                            return nil
//                    }
//                    
//                    return PhotoColor(red: Int(r),
//                                      green: Int(g),
//                                      blue: Int(b),
//                                      colorName: closestPaletteColor)
//                })
//                
//                // 5.
//                completion(photoColors)
//        }
    }
}
