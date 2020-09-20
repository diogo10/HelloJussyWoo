//
//  IngredientsView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 30/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import SwiftUIRefresh

struct DatasheetsView: View {
    @ObservedObject var viewModel = DatasheetsListViewModel()
    @State private var isShowing = false
    
    var body: some View {
        
        List {
            ForEach(viewModel.list) { section in
                
                NavigationLink(destination: ManageDatasheetView() ) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(section.name)").bold().font(.subheadline).foregroundColor(.black)
                                Text("\(section.produtcs.count) products").foregroundColor(.black).font(.caption)
                            }
                            
                            Spacer()
                            Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.price))").bold().font(.subheadline).foregroundColor(.black)
                            
                        }.padding()
                    }
                }
                
                
            }.onDelete(perform: self.deleteItem)
            
            
        }.onAppear {
            self.viewModel.load()
        }.pullToRefresh(isShowing: $isShowing) {
            self.viewModel.load()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
            }
        }
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
    }

}

class DatasheetsListViewModel : BaseViewModel,ObservableObject {
    
    @Published var list: [Datasheet] = []
    
    override init() {
        super.init()
        self.list =  datasheetRepository.getAll()
    }
    
    func load()  {
        self.list = datasheetRepository.getAll()
    }
    
    func delete(index: [Int]) {
        datasheetRepository.delete(index: index)
        load()
    }
    
}
