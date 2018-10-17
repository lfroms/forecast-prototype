//
//  Weather.swift
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
    static var siteData: SiteData?
    
    static func getSiteData() -> SiteData {
        return siteData!
    }
    
    static func setSiteData(data: SiteData) {
        siteData = data
    }
    
    static func fetchWeather(stationCode: String) -> Promise<SiteData> {
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
                            let site: SiteData = try xml["siteData"].value()
                            
                            self.setSiteData(data: site);
                            pr.fulfill(self.getSiteData())
                            
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

