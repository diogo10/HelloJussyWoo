//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data


class ContentViewV2Model {
    @Published var list: [MoneyEntry] = []
    
    func getValues(result: @escaping ([MoneyEntry]) -> Void) {
        AppDependencies.shared.authRepo.signIn(email: "diogjp10@gmail.com", password: "123456") {
            hasLogged in
            AppDependencies.shared.salesRepo.getAll  { values in
                self.list = values
            }
        }
    }
    
}

struct ContentViewV2: View {
    @State private var selection = 2
    @State private var selectionTitle = ["Ingredients","Datasheets", "Taxes", "Sales"]
    
    private var financeViewModel = FinanceViewModel()
    private var taxesViewModel = TaxesViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.black
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor.black
        
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.black
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemPink
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemPink], for: .normal)
    }
    
    var body: some View {
        
        NavigationView {
            TabView(selection: self.$selection){
                
                ProductsView().tabItem {
                    VStack {
                        Image(systemName: "cart")
                        Text("Ingredients")
                    }
                    
                }.tag(0)
                
                DatasheetsView().tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Datasheets")
                    }
                    
                }.tag(1)
                
                TaxesView(viewModel: taxesViewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "arkit")
                            Text("Taxes").foregroundColor(.accentColor)
                        }
                }.tag(2)
                

                FinanceView(viewModel: financeViewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "bag")
                            Text("Sales").foregroundColor(.accentColor)
                        }
                } .tag(3)
                
            }.accentColor(.white)
            .navigationBarTitle(self.selectionTitle[self.selection])
            .navigationBarItems(trailing: iconView())
            
             
        }
    }
    
    @State var isLinkActive = false
    private var imageTopSpace = CGFloat(10)
    
    private func iconView() -> some View {
        
        let shouldBeVisible = self.selection != 2
        
        return NavigationLink(destination:  defineDestination() , isActive: $isLinkActive) {
            Button(action: {
                print("clicked on plus")
                self.isLinkActive = true
            }) {
                Image(systemName: defineIconName())
                    .resizable()
                    .padding(6)
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }.padding(.top,imageTopSpace).opacity(shouldBeVisible ? 1 : 0)
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
             return AnyView(EmptyView())
        }
    }
    
    private func defineIconName() -> String {
        if self.selection == 0 {
            return "plus"
        }else if self.selection == 1 {
            return "plus"
        }else if self.selection == 2 {
            return "plus"
        }else if self.selection == 3 {
            return "plus"
        } else {
             return "person"
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
