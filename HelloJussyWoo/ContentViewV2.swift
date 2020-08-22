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
    @State private var options = ["Finance", "Settings"]
    
    var body: some View {
        
            NavigationView {
                TabView(selection: self.$selection){
            
                    FinanceView().tabItem {
                        VStack {
                            Image("bag")
                            Text("Finance")
                        }
                        
                    }.tag(0)
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image("config")
                                Text("Settings")
                            }
                    }
                    .tag(1)
                
                }
                
            }.onAppear {
                //UITableView.appearance().separatorStyle = .none
            }
            
        
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}

//ViewModifiers

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}
