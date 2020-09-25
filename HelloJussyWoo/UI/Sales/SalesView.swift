//
//  SalesView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class SalesViewModel: BaseViewModel, ObservableObject {
    
    @Published var list: [Sales] = []
    
    func load() {
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
    @ObservedObject var viewModel: SalesViewModel = SalesViewModel()
    @State private var isShowing = false
    
    var body: some View {
        List {
            ForEach(viewModel.list) { section in
                
                NavigationLink(destination: EmptyView() ) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(section.name)").bold().font(.subheadline).foregroundColor(.black)
                                Text("\(section.client)").foregroundColor(.black).font(.caption)
                            }
                            
                            Spacer()
                            Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.total))").bold().font(.subheadline).foregroundColor(.black)
                            
                        }.padding()
                    }
                }
                
                
            }.onDelete(perform: self.deleteItem)
            
            
        }.onAppear {
            self.viewModel.load()
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
