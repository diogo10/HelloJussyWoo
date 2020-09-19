//
//  ManageFixedExpenses.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 25/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class ManageFixedExpensesViewModel : FixedExpensesViewModel {
    private var id: String = ""
    var name: String?
    var double: Double?
    
    
    func setId(id: String) {
        self.id = id
    }
    
    func initValues() {
        let item = repoExpenses.getFixedExpense(id: self.id)
        self.name = item?.name
        self.double = item?.total
    }
    
    func save(value: String, name: String) {
        let doubleValue = Double(value) ?? 0.0
        
        if doubleValue != 0.0 {
            if let item = repoExpenses.getFixedExpense(id: self.id) {
                repoExpenses.updateFixedExpense(id: item.id,value: doubleValue, name: name)
                
            }else {
                repoExpenses.addFixedExpense(value: doubleValue, name: name)
            }
        }
        
    }
    
}

struct ManageFixedExpenses: View {
    @State var value1: String = ""
    @State var value2: String = ""
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: ManageFixedExpensesViewModel
    @State var id: String = ""
    
    init(id: String) {
        self.viewModel = ManageFixedExpensesViewModel()
        self.id = id
        self.viewModel.setId(id: id)
        self.viewModel.initValues()
    }
    
    var body: some View {
        VStack {
            Form {
                
                Section(header: Text("General")) {
                    TextField("Type in the name", text: $value1).keyboardType(.default)
                }
                
                Section(header: Text("Value")) {
                    TextField("Type in your amount", text: $value2).keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        self.viewModel.save(value: self.value2, name: self.value1)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Save changes")
                    }
                }
            }
            
            
        }.navigationBarTitle("Manage")
            .listStyle(GroupedListStyle()).onAppear {
                self.value1 = self.viewModel.name ?? ""
                self.value2 = self.viewModel.double?.description ?? ""
        }
    }
}

struct ManageFixedExpenses_Previews: PreviewProvider {
    static var previews: some View {
        ManageFixedExpenses(id: "0")
    }
}
