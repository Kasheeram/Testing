//
//  ServiceProtocols.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

protocol ServiceProtocols {
    func getGenericData<T: Codable>(returnType: T.Type) async throws -> T
}


enum APIURL {
    case articalSearch
    
    var value: String {
        switch self {
        case .articalSearch: return "/svc/search/v2/articlesearch.json?q=election"
        }
    }
    
    var description: String {
        switch self {
        case .articalSearch: return "Articals"
        }
    }
}

enum CumstomError: Error {
    case invalidUrl
    case invalidRespone
    case noData
    
    var localizeDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalidRespone:
            return "Invalid Response"
        case .noData:
            return "No Data"
        }
    }
}
