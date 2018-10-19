//
//  Site.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-17.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Site: XMLIndexerDeserializable {
    let code: String
    let nameEn: String
    let nameFr: String
    let provinceCode: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Site {
        return try Site(
            code: node.value(ofAttribute: "code"),
            nameEn: node["nameEn"].value(),
            nameFr: node["nameFr"].value(),
            provinceCode: node["provinceCode"].value()
        )
    }
    
    init(code: String, nameEn: String, nameFr: String, provinceCode: String) {
        self.code = code
        self.nameEn = nameEn
        self.nameFr = nameFr
        self.provinceCode = provinceCode
    }
    
    public func save() {
        UserDefaults.standard.set(self.code, forKey: "defaultSiteCode")
        UserDefaults.standard.set(self.nameEn, forKey: "defaultSiteNameEn")
        UserDefaults.standard.set(self.nameFr, forKey: "defaultSiteNameFr")
        UserDefaults.standard.set(self.provinceCode, forKey: "defaultSiteProvinceCode")
    }
    
    public func load() -> Site {
        return Site(
            code: UserDefaults.standard.string(forKey: "defaultSiteCode")!,
            nameEn: UserDefaults.standard.string(forKey: "defaultSiteNameEn")!,
            nameFr: UserDefaults.standard.string(forKey: "defaultSiteNameFr")!,
            provinceCode: UserDefaults.standard.string(forKey: "defaultSiteProvinceCode")!
        )
    }
}
