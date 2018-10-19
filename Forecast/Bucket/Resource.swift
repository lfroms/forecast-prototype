//
//  Resource.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-18.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Alamofire
import Foundation

typealias ResourceParser = (_ str: String) throws -> Any?

class Resource: NSObject {
    public var url: URL
    private let service: Bucket
    private let parser: ResourceParser?
    
    private var _latestData: Any?
    
    public private(set) var latestData: Any? {
        get { return _latestData }
        set { _latestData = newValue }
    }
    
    private var _isLoading: Bool = false
    
    public private(set) var isLoading: Bool {
        get { return _isLoading }
        set { _isLoading = newValue }
    }
    
    init(service: Bucket, url: URL, parser: ResourceParser?) {
        self.service = service
        self.url = url.absoluteURL
        self.parser = parser
        
        super.init()
        
        latestData = nil
    }
    
    public func child(_ name: String) -> Resource {
        return service.resource(absoluteURL: url.appendingPathComponent(name), parser: self.parser)
    }
    
    public func load() {
        isLoading = true
        
        Alamofire.request(url)
            .responseString { res in
                self.isLoading = false
                
                guard res.value != nil, res.error == nil else {
                    return
                }

                if self.parser != nil {
                    do {
                        self.latestData = try self.parser!(res.value!)
                    } catch {
                        self.latestData = res.value
                    }
                    
                } else {
                    self.latestData = res.value
                }
            }
    }
}
