//
//  ListItemCellViewModel.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

class ListItemCellViewModel: Identifiable, Hashable {
    
    let id: String
    let title: String
    let description: String
    var date: String?
    var imageUrl: URL?
    
    init(doc: Doc) {
        self.id = doc.id ?? "\(UUID().uuidString)"
        self.title = doc.title?.main ?? ""
        self.description = doc.description ?? ""
        self.date = getFormattedDate(date: doc.date ?? "")
        self.imageUrl = makeImageUrl(doc.image?.first?.image ?? "")
    }
    
    // Conform to Hashable by defining the hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListItemCellViewModel, rhs: ListItemCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    private func getFormattedDate(date: String) -> String {
        if let date = Helper.customFormattedDateString(from: date) {
            return "\(date)"
        }
        return ""
    }
    
    //     MARK: - Generate full image url if not getting directly from api
    private func makeImageUrl(_ imageCode: String) -> URL? {
        URL(string: "\(AppConstant.imageBaseURL)\(imageCode)")
    }
    
}
