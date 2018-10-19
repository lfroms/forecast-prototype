//
//  Bucket.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-18.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Cache
import Foundation

class Bucket: NSObject {
    public let baseURL: URL
    private var resourceCache: MemoryStorage<Resource>
    
    init(baseURL: String) {
        self.baseURL = URL(string: baseURL)!
        
        let memoryConfig = MemoryConfig(
            expiry: .never,
            countLimit: 2048,
            totalCostLimit: 2048
        )
        
        resourceCache = MemoryStorage<Resource>(
            config: memoryConfig
        )
        
        resourceCache.removeAll()
    }
    
    public final func resource(_ path: String, parser: ResourceParser? = nil) -> Resource {
        return resource(baseURL: baseURL, path: path, parser: parser)
    }
    
    public final func resource(baseURL customBaseURL: URL, path: String, parser: ResourceParser?) -> Resource {
        let fullURL = customBaseURL.appendingPathComponent(path)
        return resource(absoluteURL: fullURL, parser: parser)
    }
    
    public final func resource(absoluteURL url: URL, parser: ResourceParser?) -> Resource {
        do {
            return try resourceCache.object(forKey: url.absoluteString)
        } catch {
            let resourceToSave: Resource = Resource(service: self, url: url, parser: parser)
            resourceCache.setObject(resourceToSave, forKey: url.absoluteString)
            return resourceToSave
        }
    }
}
