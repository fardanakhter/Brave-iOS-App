//
//  ContentView.swift
//  Brave-iOS-App
//
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = AssetListViewModel()
    @State private var searchText = ""
    @State private var searching = false
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .center){
                if searching {
                    SearchView(searchText: $searchText, searching: $searching)
                        .toolbar {
                            if searching {
                                Button("Cancel") {
                                    searchText = ""
                                    searching = false
                                    UIApplication.shared.dismissKeyboard()
                                }
                            }
                        }
                }
                
                AssetList(viewModel: viewModel, searchText: $searchText)
                
                Image("refresh", bundle: Bundle.main)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        viewModel.refresh()
                    }
            }
            .navigationBarTitle("Crypto", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: { searching.toggle()}) {
                Image(systemName: searching ? "" : "magnifyingglass")
                    .foregroundColor(.white)
                    .frame(width: searching ? 0.0 : 50)
            })
        }
        .onAppear(perform: viewModel.refresh)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            ContentView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .preferredColorScheme(.dark)
        }
    }
}
