//
//  ViewModel.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation
import Network
import SwiftUI

@MainActor
class ViewModel: ObservableObject { // high-level class
    @Published var docs: [Doc] = []
    @Published var documents: [ListItemCellViewModel] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var shouldShowError = false
    @Published var selectedDocuments: Set<ListItemCellViewModel> = []
    
    private var isConnected = true
    private let monitor = NWPathMonitor()
    
    let serviceProtocol: ServiceProtocols
    let databaseHandler: CoreDataDelegate
    
    init(serviceProtocol: ServiceProtocols = WebServices(), databaseHandler: CoreDataDelegate = CoreDataManager()) {
        // Dependiency Inverse
        self.serviceProtocol = serviceProtocol
        self.databaseHandler = databaseHandler
        startMonitoring()
    }
    
    func fetchDocuments() async {
        if isConnected {
            isLoading = true
            do {
                let result  = try await serviceProtocol.getGenericData(url: .articalSearch, returnType: DocsResponse.self)
                self.docs = result.response?.docs ?? []
                self.mapData()
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.shouldShowError = true
                self.errorMessage = (error as? CumstomError)?.localizeDescription ?? error.localizedDescription
            }
        } else {
            do { // we can add url here if we are reading data from local file, you can remove extension if you want to pass url or url as nil
                // let result = try await databaseHandler.getGenericData(url: nil, returnType: [Doc].self)
                let result = try await databaseHandler.getGenericData(returnType: [Doc].self)
                self.docs = result
                self.mapData()
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.shouldShowError = true
                self.errorMessage = (error as? CumstomError)?.localizeDescription ?? error.localizedDescription
            }
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
        
        // Call saveToCoreData to save the fetched data to Core Data
        if isConnected {
            databaseHandler.saveDataToCoreData(docs: docs)
        }
        
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return } // Unwrap self safely
            
            Task {
                await self.updateIsConnected(path.status)
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func updateIsConnected(_ status: NWPath.Status) {
        isConnected = status == .satisfied
    }
}
