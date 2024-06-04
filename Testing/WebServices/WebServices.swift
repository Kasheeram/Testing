//
//  WebServices.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

class WebServices: ServiceProtocols {
    
    private let url: APIURL
    private let urlSession: URLSession
    
    init(url: APIURL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }
    
    func getGenericData<T: Codable>(returnType: T.Type) async throws -> T {
        let fullURL = AppConstant.baseURL + url.value + "&api-key=\(AppConstant.apiKey)"
        guard let url = URL(string: fullURL) else {
            throw CumstomError.invalidUrl
        }
        do {
            let (data, _) = try await urlSession.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(returnType, from: data)
            return result
        } catch {
            throw CumstomError.invalidRespone
        }
    }
    
    
}
