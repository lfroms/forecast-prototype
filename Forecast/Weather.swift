//
//  CurrentConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import PromiseKit

class Weather {
    static var currentConditions: CurrentConditions?
    
    static func getCurrentConditions() -> CurrentConditions {
        return currentConditions!
    }
    
    static func setCurrentConditions(conditions: CurrentConditions) {
        currentConditions = conditions
    }
    
    static func fetchWeather(stationCode: String) -> Promise<CurrentConditions> {
        let err = NSError(
            domain: "GetAPIData",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Error fetching from server."])
        
        return Promise { pr in
            Alamofire.request("http://dd.weather.gc.ca/citypage_weather/xml/ON/s0000430_e.xml")
                .responseString {
                    res in
                    
                    if res.error != nil {
                        pr.reject(err)
                    }
                    
                    if let data = res.value {
                        let xml = SWXMLHash.parse(data)
                        
                        do {
                            let currentConditions: CurrentConditions = try xml["siteData"]["currentConditions"].value()
                            
                            self.setCurrentConditions(conditions: currentConditions);
                            pr.fulfill(self.getCurrentConditions())
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        pr.reject(err)
                    }
            }
        }
    }
}

