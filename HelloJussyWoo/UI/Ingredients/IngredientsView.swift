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

struct IngredientsView: View {
    var body: some View {
        TabBgView(content: {
            IngredientsListView()
        }, title: "Ingredients")
    }
}

class IngredientsListViewModel {
    func load() -> [Ingredient] {
        ingredientsServiceRepository.getAll()
    }
}

struct IngredientsListView: View {
    
    private let viewModel = IngredientsListViewModel()
    
    var body: some View {
        ASCollectionView(data: viewModel.load(), dataID: \.self) { item, _ in
            
            NavigationLink(destination: ManageIngredientView(itemId: item.id)) {
                IngredientsListItemView(section: item)
            }.frame(width: 0)
            
            
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 180),
                  itemSpacing: 2,
                  lineSpacing: 2,
                  itemSize: .absolute(180))
        }
    }
}

struct IngredientsListItemView: View {
    var section:Ingredient
    
    var body: some View {
        VStack {
            
            Text("\(section.name)")
                .foregroundColor(.white)
                .font(.caption).padding(.top,10)
            
            Spacer()
            
            Text("R$ \(section.grossCost.format())")
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

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
