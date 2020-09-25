//
//  SalesView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import SwiftUIRefresh
import Combine

class SalesViewModel: ObservableObject {
    
    @Published var list: [Sales] = []
    @Published var hasLogged = false
    
    init(){
        doLogin()
    }
    
    private func doLogin(){
        if list.isEmpty {
            AppDependencies.shared.authRepo.signIn(email: "diogjp10@gmail.com", password: "123456") { [self]
                hasLogged in
                self.hasLogged = hasLogged
                if hasLogged {
                    self.load()
                }
            }
        }
    }
    
    func load() {
        
        //        do {
        //            let dic1: NSDictionary = ["name": "ASASASAS", "client": "sasasas", "type": 1, "total": 45.0]
        //            let sale1 = try Sales(from: dic1)
        //
        //            let dic2: NSDictionary = ["name": "aaaa", "client": "dddd", "type": 1, "total": 12.1]
        //            let sale2 = try Sales(from: dic2)
        //
        //            self.list.append(sale1)
        //            self.list.append(sale2)
        //            print("sales total: \(list.count)")
        //
        //        } catch let error as NSError {
        //            print("error: " + error.description)
        //        }
        
        
        AppDependencies.shared.salesRepo.getAll { values in
            print("sales total: \(values.count)")
            self.list.append(contentsOf: values)
        }
        
        
    }
    
    func delete(index: [Int]) {
        //productsRepository.delete(index: index)
        load()
    }
}


struct SalesView: View {
    @ObservedObject var viewModel = SalesViewModel()
    @State private var isShowing = false
    
    var body: some View {
        
        List(viewModel.list, id: \.seq) { section in
            
            NavigationLink(destination: EmptyView() ) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(section.name)").bold().font(.subheadline).foregroundColor(.black)
                            Text("\(section.client)").foregroundColor(.black).font(.caption)
                        }
                        
                        Spacer()
                        Text("\(String(format: "%.2f", section.total))").bold().font(.subheadline).foregroundColor(.black)
                        
                    }.padding()
                    .foregroundColor(.yellow)
                }
            }
            
            
        }.pullToRefresh(isShowing: $isShowing) {
            self.viewModel.load()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
            }
        }
    }
    
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
    }
}


// PLAN B
//@State private var hasTimeElapsed = false
//
//    var body: some View {
//        Text(ui)
//            .onAppear(perform: delayText)  // Triggered when the view first appears. You could
//                                           // also hook the delay up to a Button, for example.
//    }
//
//    private func delayText() {
//        // Delay of 7.5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
//            hasTimeElapsed = true
//            ui = "Please enter above."
//        }
//    }
