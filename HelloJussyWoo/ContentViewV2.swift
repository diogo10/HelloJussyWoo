//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ContentViewV2: View {
    @State private var selection = 0
    @State private var options = ["Prodution", "Settings"]

    init() {
        UITabBar.appearance().barTintColor = .systemBlue
    }
    
    var body: some View {
        
            NavigationView {
                TabView(selection: self.$selection){

                     ProductionView().tabItem {
                        VStack {
                            Image("bag")
                            Text("Datasheets")
                        }
                        
                    }.tag(0)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image("config")
                                Text("Settings").foregroundColor(.accentColor)
                            }
                    }
                    .tag(1)
                
                }
            }.accentColor(.white)
            
        
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
