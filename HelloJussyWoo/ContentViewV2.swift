//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

//https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/

struct ContentViewV2: View {
    @State private var selection = 1
    @State private var selectionTitle = ["Products","Datasheet", "Settings"]
    
    init() {
        UITabBar.appearance().barTintColor = hexStringToUIColor(hex: "#009af9")
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        NavigationView {
            TabBgView(content: {
                TabView(selection: self.$selection){
                    
                    ProductsView().tabItem {
                        VStack {
                            Image(systemName: "cart")
                            Text("Products")
                        }
                        
                    }.tag(0)
                    
                    DatasheetsView().tabItem {
                        VStack {
                            Image(systemName: "square.and.pencil")
                            Text("Datasheet")
                        }
                        
                    }.tag(1)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "arkit")
                                Text("Settings").foregroundColor(.accentColor)
                            }
                    }
                    .tag(2)
                    
                }
            }, title: self.selectionTitle[self.selection])
            
            
        }.accentColor(.white)
        
        
    }
}
