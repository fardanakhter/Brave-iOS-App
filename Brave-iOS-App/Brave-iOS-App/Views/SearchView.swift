//
//  SearchView.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var searchText: String
    @Binding var searching: Bool
    
     var body: some View {
         ZStack {
             Rectangle()
                 .foregroundColor(Color.gray)
                 .opacity(0.2)
             HStack {
                 Image(systemName: "magnifyingglass")
                 TextField("Search", text: $searchText) { startedEditing in
                      if startedEditing {
                          withAnimation {
                              searching = true
                          }
                      }
                  } onCommit: {
                      withAnimation {
                          searching = false
                      }
                  }
             }
             .foregroundColor(.gray)
             .padding(.leading, 13)
         }
         .frame(height: 40)
         .cornerRadius(13)
         .padding()
     }
 }
