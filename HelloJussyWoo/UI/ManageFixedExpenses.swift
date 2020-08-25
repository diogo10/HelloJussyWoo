//
//  ManageFixedExpenses.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 25/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI


class ManageFixedExpensesViewModel : FixedExpensesViewModel {
    
    func save(value: String, name: String) {
        let doubleValue = Double(value) ?? 0.0
        if doubleValue != 0.0 {
             repoExpenses.addFixedExpense(value: doubleValue, name: name)
        }
    }

}

struct ManageFixedExpenses: View {
    @State var value1: String = ""
    @State var value2: String = ""
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: ManageFixedExpensesViewModel
 
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
            
            
        }.navigationBarTitle("Manage Fixed Expenses")
            .listStyle(GroupedListStyle())
    }
}

struct ManageFixedExpenses_Previews: PreviewProvider {
    static var previews: some View {
        ManageFixedExpenses(viewModel: ManageFixedExpensesViewModel())
    }
}
