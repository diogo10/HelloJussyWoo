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

struct ProductViewModel: Identifiable {
    let id = UUID()
    let title: String
    var list: [Product]
}

class ProductsViewModel : BaseViewModel,ObservableObject {
    
    @Published var list: [Product] = []
    @Published var values: [ProductViewModel] = []
    
    override init() {
        super.init()
        self.list =  productsRepository.getAll()
        mapValues()
    }
    
    func load()  {
        let values =  productsRepository.getAll()
        self.list = values
        mapValues()
    }
    
    func delete(index: [Int]) {
        productsRepository.delete(index: index)
        load()
    }
    
    private func mapValues(){
        self.values.removeAll()
        let mainTarget = "KG"
        let filter1 = self.list.filter { $0.unit.uppercased() == mainTarget }
        self.values.append(ProductViewModel(title: "KG", list: filter1))
        let filter2 = self.list.filter { $0.unit.uppercased() != mainTarget }
        self.values.append(ProductViewModel(title: "Others", list: filter2))
    }
    
}


struct ProductsView: View {
    
    @ObservedObject var viewModel = ProductsViewModel()
    @State private var isShowing = false
    
    var body: some View {
        
        List {
            
            
            
            ForEach(viewModel.values) { section in
                
                Section(header: Text(section.title).foregroundColor(.gray)) {
                    
                    ForEach(section.list) { item in
                        NavigationLink(destination: ManageProductView(product: item) ) {

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.name)").bold().font(.subheadline).foregroundColor(.white)
                                    Text("\(item.unit)").foregroundColor(.white).font(.caption)
                                }

                                Spacer()
                                Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", item.price))").bold().font(.subheadline).foregroundColor(.white)

                            }.padding()

                        }
                    }
                    

                    
                }.modifier(SectionHeaderStyle())
                
            }.onDelete(perform: self.deleteItem).listRowBackground(Color.black)
            
            
            
            
            
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
