//
//  ManagePricingItemView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 04/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class ManagePricingItemViewModel  {
    var isEditing = false
    var model: Pricing?
    
    func load(id: String) {
        if id != "" {
            isEditing = true
        }
    }
    
    func save(name: String) {
        
    }
    
    func getIngredients() -> [String] {
        return ["Apples", "Oranges", "Bananas", "Pears", "Mangos", "Grapefruit"]
    }
    
    func totalInIngredients() -> String {
        return "\(repoExpenses.getCurrency()) 00,00"
    }
    
    func profit() -> String {
        return "\(repoExpenses.getCurrency()) 00,00"
    }
    
}

struct NextView: View {
    @ObservedObject var provider: IngredientsProvider
    
    @State var items: [String] = []
    @State var selections: [String] = []
    
    var body: some View {
        
        NoIconBgView(content: {
           List {
                ForEach(self.items, id: \.self) { item in
                    MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                        if self.selections.contains(item) {
                            self.selections.removeAll(where: { $0 == item })
                        }
                        else {
                            self.selections.append(item)
                        }
                        self.provider.load(selections: self.selections)
                    }
                }
                .foregroundColor(.blue)
                
            }.onAppear {
                self.items = self.provider.list
            }
        }, title: "Ingredients")
        
        
        
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct ManagePricingItemView: View {
    var itemId: String
    @Environment(\.presentationMode) var presentation
    
    @State var name: String = ""
    
    private let viewModel = ManagePricingItemViewModel()
    private let item: IngredientsProvider
    
    init(itemId: String) {
        self.itemId = itemId
        item = IngredientsProvider(list: viewModel.getIngredients())
    }
    
    var body: some View {
        NoIconBgView( content: {
            VStack {
                Form {
                    Section(header: Text("General").fontWeight(.bold)) {
                        TextField("Type in the name", text: self.$name).keyboardType(.default).accentColor(.blue)
                        
                    }
                    
                    Section(header: Text("Ingredients").fontWeight(.bold)) {
                        NavigationLink(destination: NextView(provider: self.item) ) {
                            Text(self.item.values.description).accentColor(.blue)
                        }
                        
                    }
                    
                    Section(header: Text("Profit").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Margem de Lucro").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Preço de Venda").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Custo/Kg").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Custo Total:").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Rendimento (Peso final após pronto)").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section(header: Text("Peso Total dos Ingredientes").fontWeight(.bold)) {
                        Text(self.viewModel.profit())
                    }
                    
                    Section {
                        Button(action: {
                            self.viewModel.save(name: self.name)
                            self.presentation.wrappedValue.dismiss()
                            
                        }) {
                            Text("Save changes").foregroundColor(.blue)
                        }
                    }
                }.foregroundColor(Color.black).background(Color.white)
            }.onAppear {
                self.item.list = self.viewModel.getIngredients()
                if self.viewModel.isEditing == false {
                    self.viewModel.load(id: self.itemId)
                    self.name = self.viewModel.model?.name ?? ""
                }
                
            }
        }, title: "Pricing")
        
    }
}
