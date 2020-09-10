//
//  ProductionView.swift
//  HelloJussyWoo
//https://coderabbit.at/blog/custom-header-view-in-swiftui/
//  Created by Diogo Ribeiro on 28/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import Combine

struct ProductionView: View {
    let subTitle: String = ""
    var bgColor: Color = .blue
    var body: some View {
       TabBgView(content: {
            VStack(alignment: .leading) {
                ProductionViewItems()
                Spacer()
            }
        }, title: "Datasheets")
        
    }
    
}





class ProductionViewItemsViewModel: ObservableObject {
    @Published var list = [Ingredient]()
    
    func loadAll() {
        self.list = ingredientsServiceRepository.getAll().reversed()
    }
}

struct ProductionViewItems: View {
    @ObservedObject var viewModel = ProductionViewItemsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink(destination: ManageDatasheetView(itemId: "")) {
                HStack{
                    Text("Ingredients")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 28, height: 28)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(viewModel.list) { section in
                        
                        VStack {
                            
                            Text("\(section.name)")
                                .foregroundColor(.white)
                                .font(.title).padding(.top,10)
                            
                            Spacer()
                            
                            VStack (alignment: .leading) {
                                
                                Text("* \(section.unit)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                                Text("* \(section.amountPaidEachProduct.format()) per product")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                                Text("* R$ \(section.grossCost.format()) gross amout")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            
                            
                        }.frame(width: 200, height: 200).background(Color.blue).cornerRadius(4)
                        
                        
                        
                    }
                }
            }
            
        }.padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 0)).onAppear {
            self.viewModel.loadAll()
        }
        
    }
}

struct ProductionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionView()
    }
}
