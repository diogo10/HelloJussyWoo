//
//  ProductsView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 05/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class ProductsViewModel : BaseViewModel {
    
    @Published var list: [Product] = []
    
    override init() {
        super.init()
        self.load()
    }
    
    func load()  {
        var values =  productsRepository.getAll()
        if values.isEmpty {
            values.append(productsRepository.emptyProduct())
        }
        self.list.append(contentsOf: values)
    }
    
}


struct ProductsView: View {
    
    private let viewModel = ProductsViewModel()
    
    var body: some View {
        TabBgView(content: {
            VStack(alignment: .leading) {
                ForEach(viewModel.list.reversed(), id: \.self) { section in
                    
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
                            Divider()
                        }
                    }
                }
            }.onAppear {
                self.viewModel.load()
            }
            
            
            
        }, title: "Products")
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
