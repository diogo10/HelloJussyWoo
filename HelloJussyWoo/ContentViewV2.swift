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
    
    
    init() {
        UITabBar.appearance().barTintColor = .systemPink
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
            NavigationView {
                TabView(selection: self.$selection){

                     ProductionView().tabItem {
                        VStack {
                            Image(systemName: "list.dash")
                            Text("Home")
                        }
                        
                    }.tag(0)
                    
                    IngredientsView().tabItem {
                        VStack {
                            Image(systemName: "square.and.pencil")
                            Text("Ingredients")
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
            }.accentColor(.white)
            
        
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
