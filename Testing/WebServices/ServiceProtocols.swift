//
//  ServiceProtocols.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

protocol ServiceProtocols {
    func getGenericData<T: Codable>(url: APIURL?, returnType: T.Type) async throws -> T
}

extension ServiceProtocols {
    func getGenericData<T: Codable>(returnType: T.Type) async throws -> T {
        return try await getGenericData(url: nil, returnType: returnType)
    }
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
        case .articalSearch: return "Artical"
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
