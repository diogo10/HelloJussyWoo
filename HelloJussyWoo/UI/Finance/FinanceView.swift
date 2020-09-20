//
//  FinanceView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data


class FinanceViewModel: BaseViewModel, ObservableObject {
    
    @Published var month = ""
    @Published var year = ""
    @Published var total = ""
    @Published var list: [MoneyEntry] = []
    
    var calendar = Calendar.current
    var currentDate = Date()
    
    
    override init() {
        super.init()
        updateTime()
        self.list =  moneyEntryRepository.getAll()
        updateTotal()
    }
    
    func load()  {
        updateTime()
        self.list =  moneyEntryRepository.getAll()
        updateTotal()
    }
    
    func back()  {
        manageTime(month: -1)
        updateTime()
    }
    
    func next()  {
        manageTime(month: 1)
        updateTime()
    }
    
    func delete(index: [Int]) {
        moneyEntryRepository.delete(index: index)
        load()
    }
    
    //MARK: --
    
    private func manageTime(month: Int){
        var dateComponent = DateComponents()
        dateComponent.month = month
        currentDate = calendar.date(byAdding: dateComponent, to: currentDate) ?? Date()
    }
    
    private func updateTime(){
        if let monthInt = calendar.dateComponents([.month], from: currentDate).month {
            self.month = calendar.monthSymbols[monthInt-1]
        }
        
        if let year = calendar.dateComponents([.year], from: currentDate).year {
            self.year = year.description
        }
    }
    
    private func updateTotal(){
        let value = self.list.map({$0.total}).reduce(0, +)
        total = getCurrency() + " \(value.format())"
    }
    
}

struct FinanceView: View {
    @ObservedObject var viewModel = FinanceViewModel()
    @State private var isShowing = false
    
    var body: some View {
        
        List { Section(header: ListHeader(viewModel: viewModel).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))) {
            ForEach(viewModel.list) { section in
                
                NavigationLink(destination: ManageFinanceView(data: section) ) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(section.name)").bold().font(.subheadline).foregroundColor(.black)
                                Text("\(section.date.simpleFormat())").foregroundColor(.black).font(.caption)
                            }
                            
                            Spacer()
                            Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.total))").bold().font(.subheadline).foregroundColor(.black)
                            
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
        
        
        }.listStyle(GroupedListStyle())
        
        
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
    }
}

// - MARK:

private struct ListHeader: View {
    @ObservedObject var viewModel: FinanceViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                HStack {
                    Button(action: {
                        viewModel.back()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    
                    VStack{
                        Text("\(viewModel.month)").font(.caption)
                        Text("\(viewModel.year)").font(.caption)
                    }.frame(width: 80)
                    
                    Button(action: {
                        viewModel.next()
                    }) {
                        Image(systemName: "arrow.right")
                    }
                }
                
                Spacer()
                VStack{
                    Text("\(viewModel.total)").bold().font(.title).foregroundColor(.blue)
                }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                
                VStack {
                    
                    Button(action: { }) {
                        Image("linechart").frame(width: 50, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                                    .foregroundColor(.orange))
                    
                    Text("Graph").font(.caption)
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 5))
            
            HStack {
                Text("Transations").bold().font(.subheadline)
                Spacer()
                Button(action: {
                    print("more filter")
                }) {
                    HStack {
                        Text("....").bold().foregroundColor(.blue)
                    }
                }
                
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }
    }
}
