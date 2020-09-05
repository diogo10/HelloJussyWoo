//
//  Pickers.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 05/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

let units: [String] = ["Kg=quilo", "Lt=litro", "Mç=maço", "Us=unidade", "Co=consumo de óleo", "Dz=dúzia", "Qb=quanto baste"]

public class IngredientsProvider: ObservableObject {
    
    var list: [String] = []
    @Published var values: [String] = []
    
    init(list: [String]) {
        self.list = list
    }
    
    func load(selections: [String]) {
        self.values = selections
    }
}


public class UnitProvider: BaseSimpleProvider {
    
    override init(list: [String]) {
        super.init(list: list)
    }

    
}

public class BaseSimpleProvider: ObservableObject {
    var list: [String] = units
    @Published var values: [String] = []
    
    init(list: [String]) {
        self.list = list
    }
    
    func load(selections: [String]) {
        self.values = selections
    }
    
    func prettyValues() -> String {
       let value =  self.values.toPrint
        if value.isEmpty {
            return "Select one option"
        }else {
            return value
        }
    }
}

struct SingleSelectionViewProvider: View {
    @ObservedObject var provider: BaseSimpleProvider
    @Environment(\.presentationMode) var presentation
    @State var items: [String] = []
    @State var selections: [String] = []
    
    var title: String
    
    var body: some View {
        
        NoIconBgView(content: {
           List {
                ForEach(self.items, id: \.self) { item in
                    MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                        self.provider.load(selections: [item])
                        self.presentation.wrappedValue.dismiss()
                    }
                }
                .foregroundColor(.blue)
                
            }.onAppear {
                self.items = self.provider.list
            }
        }, title: title)
        
        
        
    }
}

struct MultiSelectionViewProvider: View {
    @ObservedObject var provider: BaseSimpleProvider
    
    @State var items: [String] = []
    @State var selections: [String] = []
    
    var title = ""
    
    
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
        }, title: title)
        
        
        
    }
}
