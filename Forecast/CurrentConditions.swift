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

class CurrentConditions {
    static func getCurrentConditions() -> Promise<XMLIndexer> {
        return Promise { pr in
            Alamofire.request("http://dd.weather.gc.ca/citypage_weather/xml/ON/s0000430_e.xml")
                .responseString {
                    res in
                    
                    let xml = SWXMLHash.parse(res.value!)
                    pr.fulfill(xml["siteData"])
            }
        }
    }
}

