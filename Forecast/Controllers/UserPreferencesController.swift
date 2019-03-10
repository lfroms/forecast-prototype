//
//  UserPreferencesController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-09.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    case siteCode = "defaultSiteCode"
    case provinceCode = "defaultProvinceCode"
}

struct SavedSite {
    var code: Int
    var region: Region
}

extension SiteListQuery.Data.Site {
    func saveAsDefault() {
        UserDefaults.standard.set(self.code, forKey: UserDefaultKeys.siteCode.rawValue)
        UserDefaults.standard.set(self.provinceCode, forKey: UserDefaultKeys.provinceCode.rawValue)
    }
}

func defaultSite() -> SavedSite? {
    guard savedSiteExists() else {
        return nil
    }

    let siteCode = UserDefaults.standard.integer(forKey: UserDefaultKeys.siteCode.rawValue)
    let provinceCode = UserDefaults.standard.string(forKey: UserDefaultKeys.provinceCode.rawValue)
    let region = Region(rawValue: provinceCode!)

    guard region != nil else {
        return nil
    }

    return SavedSite(code: siteCode, region: region!)
}

func savedSiteExists() -> Bool {
    return
        UserDefaults.standard.integer(forKey: UserDefaultKeys.siteCode.rawValue) != 0 &&
        UserDefaults.standard.string(forKey: UserDefaultKeys.provinceCode.rawValue) != nil
}
