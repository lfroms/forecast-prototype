//
//  UserPreferencesController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-09.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

func saveAsDefault(_ site: SiteListQuery.Data.Site?) {
    if site == nil {
        return
    }

    UserDefaults.standard.set(site?.code, forKey: "defaultSiteCode")
    UserDefaults.standard.set(site?.nameEn, forKey: "defaultSiteNameEn")
    UserDefaults.standard.set(site?.nameFr, forKey: "defaultSiteNameFr")
    UserDefaults.standard.set(site?.provinceCode, forKey: "defaultSiteProvinceCode")
}

func defaultSite() -> SiteListQuery.Data.Site {
    return SiteListQuery.Data.Site(
        nameEn: UserDefaults.standard.string(forKey: "defaultSiteNameEn") ?? "Ottawa (Kanata - Orléans)",
        nameFr: UserDefaults.standard.string(forKey: "defaultSiteNameFr") ?? "Ottawa (Kanata - Orléans)",
        code: UserDefaults.standard.integer(forKey: "defaultSiteCode"),
        provinceCode: UserDefaults.standard.string(forKey: "defaultSiteProvinceCode") ?? "ON"
    )
}
