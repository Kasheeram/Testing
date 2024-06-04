//
//  DocsResponse.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation


struct DocsResponse: Codable {
    let response: Response?
}

struct Response: Codable {
    let docs: [Doc]?
}

struct Doc: Codable {
    let description: String?
    let title: Headline?
    let date: String?
    let image: [Multimedia]?
    
    enum CodingKeys: String, CodingKey {
        case description = "abstract"
        case date = "pub_date"
        case title = "headline"
        case image = "multimedia"
    }
}

struct Headline: Codable {
    let main: String?
}

struct Multimedia: Codable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "url"
    }
}
