//
//  ProductionView.swift
//  HelloJussyWoo
//https://coderabbit.at/blog/custom-header-view-in-swiftui/
//  Created by Diogo Ribeiro on 28/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

struct ProductionView: View {
    let title: String = "Datasheets"
    let subTitle: String = "Good morning"
    var bgColor: Color = .blue
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(self.bgColor)
                    .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Text(self.subTitle)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                    }
                    .padding(.leading, 25).padding(.top, 40)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        NavigationLink(destination: EmptyView()) {
                            
                            Image(systemName: "linechart")
                                .resizable()
                                .padding(6)
                                .frame(width: 28, height: 28)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                    }.padding(.trailing, 20).padding(.top, 40)
                    
                    
                }.edgesIgnoringSafeArea(.all)
                
                
            }
            
            VStack(alignment: .leading) {
                ProductionViewItems().padding(.top, 30)
                Spacer()
            }
            
            
            
        }
        
    }
    
}


class ProductionViewItemsViewModel {
    func loadAll() -> [Ingredient] {
        return ingredientsServiceRepository.getAll()
    }
}

struct ProductionViewItems: View {
    private let viewModel = ProductionViewItemsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink(destination: ManageProductView()) {
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
                    ForEach(viewModel.loadAll()) { section in
                        
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
            
        }.padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 0))
        
    }
}

struct ProductionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionView()
    }
}
