//
//  ImageCacheProtocol.swift
//  YouTube
//
//  Created by Shai Ariman on 28/04/2020.
//  Copyright © 2020 Shai Ariman. All rights reserved.
//

import Foundation

public struct DataCache {
    
    private let cache = NSCache<NSString, CachedValueAsClass<Data>>()
    
    private let requestDataHander : (String, @escaping (String, Data?)->())->()
    
    public init(requestDataHander : @escaping (String, @escaping (String, Data?)->())->()) {
        self.requestDataHander = requestDataHander
    }
    
    public func getData(forKey key : String, completion : @escaping (Data?)->()) {
        if let cachedValue = cache.object(forKey: key as NSString) {
            completion(cachedValue.value)
        } else {
            //request data and add to cache on completion
            self.requestDataHander(key, { key, data in
                if let data = data {
                    self.cache.setObject(CachedValueAsClass(value: data), forKey: key as NSString)
                } else {
                    self.cache.removeObject(forKey: key as NSString)
                }
                completion(data)
            })
        }
    }
    
    final private class CachedValueAsClass<Value> {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}



