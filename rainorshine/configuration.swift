//
//  Configuration.swift
//  rainorshine
//
//  Created by Mike Taylor on 09/05/2017.
//  Copyright © 2017 Mike Taylor. All rights reserved.
//

import Foundation

struct Defaults {
    
    static let Latitude: Double = 52.245745
    static let Longitude: Double = -7.137346
    
}

struct API {
    
    static let APIKey = "b9296766cfc834a06c1418a4f419e063"
    static let BaseURL = URL(string: "https://api.forecast.io/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
    
}

