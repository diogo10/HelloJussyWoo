//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ContentViewV2: View {
    @State private var selection = 1

    init() {
        UITabBar.appearance().barTintColor = .systemBlue
    }
    
    var body: some View {
        
            NavigationView {
                TabView(selection: self.$selection){

                     ProductionView().tabItem {
                        VStack {
                            Image("bag")
                            Text("Home")
                        }
                        
                    }.tag(0)
                    
                    IngredientsView().tabItem {
                        VStack {
                            Image("baking")
                            Text("Ingredients")
                        }
                        
                    }.tag(1)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image("config")
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
