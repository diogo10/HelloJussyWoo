//
//  ConfigurationView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import Data

var repoExpenses = ExpensesServiceRepository()

class FixedExpensesViewModel : ObservableObject{
    
    @Published var list = [FixedExpense]()
    @Published var isLoading: Bool = false
    
    func load() {
        repoExpenses.getFixedExpense() { values in
            self.list = values
        }
    }
    
    func delete(index: [Int]) {
        repoExpenses.deleteFixedExpense(index: index)
        load()
    }
    
    func total() -> String {
        return String(format: "\(repoExpenses.getCurrency()) %.2f", repoExpenses.total())
    }
}

struct FixedExpensesView: View {
    
    @State private var valueText = ""
    @ObservedObject var viewModel: FixedExpensesViewModel
    
    var body: some View {
        List {
            Section(header: Text("General"), footer: FixedExpensesListFooter(value: viewModel.total() )) {
                ForEach(viewModel.list) { section in
                    
                    NavigationLink(destination: ManageFixedExpenses(id: section.id) ) {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(section.name)").bold().font(.subheadline)
                                    Text("").font(.caption)
                                }
                                
                                Spacer()
                                Text("R$ \(String(format: "%.2f", section.total))").bold().font(.subheadline)
                            }.padding()
                        }
                    }
                    
                    
                }.onDelete(perform: self.deleteItem)
            }
            
        }.onAppear {
            self.viewModel.load()
        }
        .navigationBarTitle("Fixed Expenses")
        .listStyle(GroupedListStyle())
        .navigationBarItems(trailing: NavigationLink(destination: ManageFixedExpenses(id: "") ) {
            AddButtonView()
        })
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
        
    }
}
struct AddButtonView: View {
    var body: some View {
        Text("Add").foregroundColor(Color.blue)
    }
}

private struct FixedExpensesListFooter: View {
    var value = ""
    var body: some View {
        Text("Total: R$ \(value)")
    }
}

struct FixedExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        FixedExpensesView(viewModel: FixedExpensesViewModel())
    }
}
