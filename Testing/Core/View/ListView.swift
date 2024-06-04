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
                LazyVStack {
                    ForEach(viewModel.documents) { doc in
                        ListItemView(docItem: doc)
                        
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
