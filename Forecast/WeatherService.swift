//
//  WeatherService.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-17.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

enum LanguageCode: String {
    case english = "e"
    case french = "f"
}

class WeatherService: Bucket {
    init() {
        super.init(baseURL: "http://dd.weather.gc.ca/citypage_weather/xml")
    }

    private let siteListParser: ResourceParser = { data in
        let index = SWXMLHash.parse(data)
        return try index["siteList"]["site"].value() as [Site]
    }
    
    private let siteDataParser: ResourceParser = { data in
        let index = SWXMLHash.parse(data)
        return try index["siteData"].value() as SiteData
    }

    var siteList: Resource {
        return resource("/siteList.xml", parser: siteListParser)
    }
    
    func siteData(site: Site, lang: LanguageCode) -> Resource {
        let name = site.code + "_" + lang.rawValue + ".xml"
        return resource("/", parser: siteDataParser).child(site.provinceCode).child(name)
    }
}
