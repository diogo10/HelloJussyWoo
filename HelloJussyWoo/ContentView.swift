//
//  ContentView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var showingActionSheet = false
    @State private var options = ["Orders","Configuration"]
    @ObservedObject var viewModel: OrdersViewModel
    
    
    var body: some View {
        
        LoadingView(isShowing: .constant(self.viewModel.isLoading)) {
            NavigationView {
                TabView(selection: self.$selection){
                    List(self.viewModel.list){ i in
                        OrderView(placeholder: i).cornerView().contextMenu {
                            Button(action: {
                                self.viewModel.changeStatus(status: .PROCESSING, orderId: i.id)
                            }) {
                                Text("Change to: In processing")
                            }
                            Button(action: {
                                self.viewModel.changeStatus(status: .COMPLETED, orderId: i.id)
                            }) {
                                Text("Change to: Completed")
                            }
                        }
                    }.tabItem {
                        VStack {
                            Image("bag")
                            Text("Orders")
                        }
                    }
                    .tag(0).opacity(self.viewModel.isLoading ? 0 : 1)
                    ConfigurationView(viewModel: ConfigurationViewModel())
                        .tabItem {
                            VStack {
                                Image("config")
                                Text("Configuration")
                            }
                    }
                    .tag(1)
                }
                .navigationBarTitle(self.options[self.selection])
                .navigationBarItems(leading: Button("Filter") {
                    self.showingActionSheet = true
                }.actionSheet(isPresented: self.$showingActionSheet) {
                    ActionSheet(title: Text("Filter"), message: Text("Select the status type"), buttons: [
                        .default(Text("On hold")) {
                            self.viewModel.getAll(status: .ONHOLD)
                        },
                        .default(Text("Completed")) {
                            self.viewModel.getAll(status: .COMPLETED)
                        },
                        .default(Text("Cancelled")) {
                            self.viewModel.getAll(status: .CANCELED)
                        },
                        .default(Text("All")) {
                            self.viewModel.getAll(status: .ANY)
                        },
                        .cancel()
                    ])
                })
            }.onAppear {
                UITableView.appearance().tableFooterView = UIView()
                UITableView.appearance().separatorStyle = .none
            }
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: OrdersViewModel())
    }
}
