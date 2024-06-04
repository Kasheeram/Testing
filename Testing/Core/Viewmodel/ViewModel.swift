//
//  ViewModel.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    @Published var docs: [Doc] = []
    @Published var documents: [ListItemCellViewModel] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var shouldShowError = false
    
    let serviceProtocol: ServiceProtocols
    
    init(serviceProtocol: ServiceProtocols = WebServices(url: .articalSearch)) {
        self.serviceProtocol = serviceProtocol
    }
    
    func fetchDocuments() async {
        isLoading = true
        do {
            let result  = try await serviceProtocol.getGenericData(returnType: DocsResponse.self)
            self.docs = result.response?.docs ?? []
            self.mapData()
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.shouldShowError = true
            self.errorMessage = (error as? CumstomError)?.localizeDescription ?? error.localizedDescription
        }
    }
    
    private func mapData() {
        self.docs = docs.sorted { (doc1, doc2) in
            guard let date1 = doc1.date, let date2 = doc2.date else {
                if doc1.date == nil && doc2.date == nil {
                    return true
                } else if doc1.date == nil {
                    return true
                } else {
                    return false
                }
            }
            return date1 < date2
        }
        self.documents = docs.compactMap({ListItemCellViewModel(doc: $0)})
    }
}
