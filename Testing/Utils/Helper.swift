//
//  Helper.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

class Helper {
    static func inputDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    static func customFormattedDateString(from dateString: String) -> String? {
        let inputFormatter = inputDateFormatter()
        if let date = inputFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMMM yyyy"
            return outputDateFormatter.string(from: date)
        }
        return nil
    }
}
