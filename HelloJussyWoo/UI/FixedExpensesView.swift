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
                
                    NavigationLink(destination: Text(section.name) ) {
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
                    
                    
                }
            }
                
            
        }.onAppear {
            self.viewModel.load()
        }
        .navigationBarTitle("Fixed Expenses")
        .listStyle(GroupedListStyle())
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
