//
//  ApiManager.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/17/24.
//

import Foundation

func getAPIUrl(for endpoint: String) -> URL? {
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path),
       let baseUrlString = dict["API_URL"] as? String {
        return URL(string: "\(baseUrlString)/\(endpoint)")
    }
    return nil
}
