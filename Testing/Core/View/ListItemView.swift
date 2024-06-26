//
//  ListItemView.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import SwiftUI

struct ListItemView: View {
    let docItem: ListItemCellViewModel
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(docItem.title)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text(docItem.date ?? "")
                        .font(.footnote)
                        .fontWeight(.regular)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            AsyncImage(url: docItem.imageUrl, scale: 2.0) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } placeholder: {
                Color.gray
            }
            .frame(width: UIScreen.main.bounds.width-32, height: 250)
            
            Text(docItem.description)
        }
        .padding(16)
        .onTapGesture {
            isSelected.toggle()
        }
        Divider()
        
        
    }
}

//#Preview {
//    ListItemView(docItem: )
//}
