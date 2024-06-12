//
//  ContentView.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack { // we can remove the Identifiable from ListItemCellViewModel but you need to use
                    // ForEach(viewModel.documents, id: \.self), because we are using Hashable that will create a unique id by hasher.combine(id)
                    ForEach(viewModel.documents) { doc in
                        ListItemView(
                            docItem: doc,
                            isSelected: Binding(
                                get: { viewModel.selectedDocuments.contains(doc) },
                                set: { isSelected in
                                    if isSelected {
                                        viewModel.selectedDocuments.insert(doc)
                                    } else {
                                        viewModel.selectedDocuments.remove(doc)
                                    }
                                }
                            )
                        )
                    }
                }
            }
            .overlay(
                Group {
                    // show loading view when fetching data from server
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(2.0, anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                }
            )
            .navigationTitle(APIURL.articalSearch.description)
            Button("Show selected articles", action: {
                viewModel.selectedDocuments.forEach { item in
                    print(item.title)
                }
            })
            
        }
        .task {
            await viewModel.fetchDocuments()
        }
        .alert(isPresented: $viewModel.shouldShowError) {
            // show alert message when any error occured
            Alert(title: Text("Important message"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("Got it!")))
        }
    }
}

#Preview {
    ListView()
}
