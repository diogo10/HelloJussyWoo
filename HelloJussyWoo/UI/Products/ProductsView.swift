//
//  ProductsView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 05/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import SwiftUIRefresh

class ProductsViewModel : BaseViewModel {
    
    @Published var list: [Product] = []
    
    override init() {
        super.init()
        self.list =  productsRepository.getAll()
    }
    
    func load()  {
        var values =  productsRepository.getAll()
        if values.isEmpty {
            values.append(productsRepository.emptyProduct())
        }
        self.list = values
        
    }
    
    
    func delete(index: [Int]) {
        productsRepository.delete(index: index)
        load()
    }
    
}


struct ProductsView: View {
    
    @ObservedObject var viewModel = ProductsViewModel()
    @State private var isShowing = false
    var body: some View {
        TabBgView(content: {
            
            
            List {
                ForEach(viewModel.list) { section in
                    
                    NavigationLink(destination: ManageProductView(product: section) ) {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(section.name)").bold().font(.subheadline).foregroundColor(.black)
                                    Text("\(section.unit)").foregroundColor(.black).font(.caption)
                                }
                                
                                Spacer()
                                Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.price))").bold().font(.subheadline).foregroundColor(.black)
                                
                            }.padding()
                        }
                    }
                    
                    
                }.onDelete(perform: self.deleteItem)
                
                
            }.onAppear {
                print("ProductsView: load")
                self.viewModel.load()
            }.pullToRefresh(isShowing: $isShowing) {
                self.viewModel.load()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                }
            }
            
        }, title: "Products")
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
