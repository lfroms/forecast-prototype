//
//  UserPreferences.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-09.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

class UserPreferences {
    enum DefaultKeys: String {
        case siteCode = "defaultSiteCode"
        case provinceCode = "defaultProvinceCode"
    }

    struct SavedSite {
        var code: Int
        var region: Region
    }

    static func defaultSite() -> SavedSite? {
        guard self.defaultSiteExists() else {
            return nil
        }

        let siteCode = UserDefaults.standard.integer(forKey: DefaultKeys.siteCode.rawValue)
        let provinceCode = UserDefaults.standard.string(forKey: DefaultKeys.provinceCode.rawValue)
        let region = Region(rawValue: provinceCode!)

        guard region != nil else {
            return nil
        }

        return SavedSite(code: siteCode, region: region!)
    }

    static func defaultSiteExists() -> Bool {
        return
            UserDefaults.standard.integer(forKey: DefaultKeys.siteCode.rawValue) != 0 &&
            UserDefaults.standard.string(forKey: DefaultKeys.provinceCode.rawValue) != nil
    }
}

extension SiteListQuery.Data.Site {
    func saveAsDefault() {
        UserDefaults.standard.set(self.code, forKey: UserPreferences.DefaultKeys.siteCode.rawValue)
        UserDefaults.standard.set(self.provinceCode, forKey: UserPreferences.DefaultKeys.provinceCode.rawValue)
    }
}
