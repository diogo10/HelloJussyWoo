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

class ProductsViewModel : BaseViewModel,ObservableObject {
    
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
        
        List {
            
            Section(header: Text("Continente").foregroundColor(.gray)) {
                
                ForEach(viewModel.list) { section in
                    
                    NavigationLink(destination: ManageProductView(product: section) ) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(section.name)").bold().font(.subheadline).foregroundColor(.white)
                                Text("\(section.unit)").foregroundColor(.white).font(.caption)
                            }
                            
                            Spacer()
                            Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.price))").bold().font(.subheadline).foregroundColor(.white)
                            
                        }.padding()
                        
                    }
                    
                    
                }.onDelete(perform: self.deleteItem).listRowBackground(Color.black)
                
            }.modifier(SectionHeaderStyle())
        }.listStyle(GroupedListStyle()).onAppear {
            print("Product")
            self.viewModel.load()
        }
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
