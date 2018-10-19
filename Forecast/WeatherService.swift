//
//  WeatherService.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-17.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import SWXMLHash

enum LanguageCode: String {
    case english = "e"
    case french = "f"
}

class WeatherService: Service {
    init() {
        super.init(baseURL: "https://dd.weather.gc.ca/citypage_weather/xml/")
        self.wipeResources()

        self.configure {
            $0.pipeline.order = [.rawData, .decoding, .parsing, .model]
        }

        self.configureTransformer("**", atStage: .decoding) {
            String(data: $0.content, encoding: .ascii)
        }

        self.configureTransformer("**", atStage: .parsing) {
            SWXMLHash.parse($0.content as String)
        }

        self.configureTransformer("/*/*", atStage: .model) {
            try ($0.content as XMLIndexer)["siteData"].value() as SiteData
        }

        self.configureTransformer("/siteList.xml", atStage: .model) {
            try ($0.content as XMLIndexer)["siteList"]["site"].value() as [Site]
        }
    }

    var siteList: Resource {
        return resource("/siteList.xml")
    }

    func siteData(site: Site, lang: LanguageCode) -> Resource {
        let name = site.code + "_" + lang.rawValue + ".xml"
        return resource("/").child(site.provinceCode).child(name)
    }
}
