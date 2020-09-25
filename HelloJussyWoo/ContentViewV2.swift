//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data


class ContentViewModel: BaseViewModel {
    let authService = AuthRepository()

    func load() {
        authService.signIn(email: "diogjp10@gmail.com", password: "123456") { _ in }
    }
}

struct ContentViewV2: View {
    @State private var selection = 2
    @State private var selectionTitle = ["Products","Datasheet", "Settings", "Sales" ,"Finance"]
    private let viewModel = ContentViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = .white
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
                    
                    SalesView()
                        .tabItem {
                            VStack {
                                Image(systemName: "bag")
                                Text("Sales").foregroundColor(.accentColor)
                            }
                    }
                    .tag(3)
                    
                    FinanceView()
                        .tabItem {
                            VStack {
                                Image(systemName: "creditcard")
                                Text("Finance").foregroundColor(.accentColor)
                            }
                    }
                    .tag(4)
                    
                }
            }, title: self.selectionTitle[self.selection])
            
            .navigationBarItems(trailing: iconView())
            
            
        }
        
        .onAppear {
            viewModel.load()
        }
    }
    
    @State var isLinkActive = false
    private var imageTopSpace = CGFloat(10)
    
    private func iconView() -> some View {
        
        return NavigationLink(destination:  defineDestination() , isActive: $isLinkActive) {
            Button(action: {
                print("clicked on plus")
                self.isLinkActive = true
            }) {
                Image(systemName: defineIconName())
                    .resizable()
                    .padding(6)
                    .frame(width: 28, height: 28)
                    .background(Color.green)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }.padding(.top,imageTopSpace)
        }
        
    }
    
    private func defineDestination() -> AnyView {
        if self.selection == 0 {
            return AnyView(ManageProductView())
        }else if self.selection == 1 {
            return AnyView(ManageDatasheetView(data: nil))
        }else if self.selection == 3 {
            return AnyView(ManageFinanceView(data: nil))
        } else {
             return AnyView(MoreView())
        }
    }
    
    private func defineIconName() -> String {
        if self.selection == 0 {
            return "plus"
        }else if self.selection == 1 {
            return "plus"
        }else if self.selection == 2 {
            return "person"
        } else {
             return "plus"
        }
    }
    
    
}

struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.red)
            .foregroundColor(Color.white)
            .font(.largeTitle)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
