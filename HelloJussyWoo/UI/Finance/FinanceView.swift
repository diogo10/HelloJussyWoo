//
//  FinanceView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import SwiftUICharts

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
        updateList()
        updateTotal()
    }
    
    func load()  {
        updateTime()
        updateList()
        updateTotal()
    }
    
    func back()  {
        manageTime(month: -1)
        updateTime()
        updateList()
        
    }
    
    func next()  {
        manageTime(month: 1)
        updateTime()
        updateList()
    }
    
    func delete(index: [Int]) {
        moneyEntryRepository.delete(index: index)
        load()
    }
    
    func pieData() -> [Double] {
        let expenses = self.list.filter({ $0.type == 0 }).map({$0.total}).reduce(0, +)
        let incomes = self.list.filter({ $0.type == 1 }).map({$0.total}).reduce(0, +)
        return [expenses,incomes]
    }
    
    func barData() -> ChartData {
        var currentMonth = 0
        var monthStr = ""
        var chart:[(String,Double)] = []
        
        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
            currentMonth = monthInt
            monthStr = Calendar.current.monthSymbols[monthInt-1]
            
        }
        
        let incomes1 = self.list.filter({
            $0.type == 0 && currentMonth == Calendar.current.dateComponents([.month], from: $0.date).month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes1))
        
        
        currentMonth = currentMonth - 1
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes2 = self.list.filter({
            $0.type == 0 && currentMonth == Calendar.current.dateComponents([.month], from: $0.date).month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes2))
        
        
        currentMonth = currentMonth - 2
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes3 = self.list.filter({
            $0.type == 0 && currentMonth == Calendar.current.dateComponents([.month], from: $0.date).month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes3))
        
        currentMonth = currentMonth - 3
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes4 = self.list.filter({
            $0.type == 0 && currentMonth == Calendar.current.dateComponents([.month], from: $0.date).month
        }).map({$0.total}).reduce(0, +)
        chart.append((monthStr,incomes4))
        
        return ChartData(values: chart)
    }
    
    //MARK: --
    
    private func updateList(){
        let times =  calendar.dateComponents([.month,.year ], from: currentDate)
        let month = times.month
        let year = times.year
        
        self.list = moneyEntryRepository.getAll().filter { entry -> Bool in
            let time = Calendar.current.dateComponents([.month,.year], from: entry.date)
            return month == time.month && year == time.year
        }
    }
    
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
        let value = self.list.filter({ $0.type == 1 }).map({$0.total}).reduce(0, +)
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
                            
                            Circle()
                                .fill(self.circleColorBy(type: section.type))
                                .frame(width: 14, height: 14)
                            
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
    
    private func circleColorBy(type: Int) -> Color {
        if type == 0 {
            return Color.red
        } else {
            return Color.green
        }
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
                    Text("\(viewModel.total)").bold().font(.title).foregroundColor(.green)
                }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        self.createPie()
                        self.createBar()
                    }
                }
                
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
    
    private func createPie() -> PieChartView {
        return PieChartView(data: self.viewModel.pieData(), title: "Resume",  dropShadow: false)
    }
    
    private func createBar() -> BarChartView {
       return BarChartView(data: self.viewModel.barData(), title: "Expenses", legend: "Quarterly", dropShadow: false) 
    }
}

