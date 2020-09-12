//
//  IngredientsView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 30/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import ASCollectionView

struct DatasheetsView: View {
    var body: some View {
        IngredientsListView()
    }
}

class IngredientsListViewModel {
    func load() -> [Ingredient] {
        ingredientsServiceRepository.getAll()
    }
    
    func getCurrency() -> String {
        repoExpenses.getCurrency()
    }
}

struct IngredientsListView: View {
    
    private let viewModel = IngredientsListViewModel()
    
    var body: some View {
        ASCollectionView(data: viewModel.load(), dataID: \.self) { item, _ in
            
            NavigationLink(destination: ManageDatasheetView(itemId: item.id)) {
                IngredientsListItemView(section: item, currency: self.viewModel.getCurrency())
            }.frame(width: 0)
            
            
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 180),
                  itemSpacing: 0,
                  lineSpacing: 0,
                  itemSize: .absolute(180))
        }
    }
}

struct IngredientsListItemView: View {
    var section:Ingredient
    var currency = ""
    var body: some View {
        VStack {
            
            Text("\(section.name)")
                .foregroundColor(.white)
                .font(.caption).padding(.top,10)
            
            Spacer()
            
            Text("\(currency) \(section.grossCost.format())")
                .foregroundColor(.white)
                .font(.title).padding(.top,10)
            
            Spacer()
            
            VStack (alignment: .leading) {
                
                Text("\(section.unit)")
                    .foregroundColor(.white)
                    .font(.caption)
                
            }
            
            Spacer()
            
        }.frame(width: 150, height: 150).background(Color.blue).cornerRadius(4)
    }
}
