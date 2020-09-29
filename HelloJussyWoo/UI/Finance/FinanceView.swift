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

//
//https://github.com/ryangittings/swiftui-bugs
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
        load()
    }
    
    func load() {
        getValues { values in}
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
        //moneyEntryRepository.delete(index: index)
        //load()
    }
    
    //MARK: --
    
    func getValues(result: @escaping ([MoneyEntry]) -> Void) {
        AppDependencies.shared.authRepo.signIn(email: "diogjp10@gmail.com", password: "123456") {
            hasLogged in
            AppDependencies.shared.salesRepo.getAll  { values in
                self.updateList(values: values)
                self.updateTotal()
                result(self.list)
            }
        }
    }
    
    private func updateList(values: [MoneyEntry]) {
        let times =  self.calendar.dateComponents([.month,.year ], from: self.currentDate)
        let month = (times.month ?? 9) - 1
        let year = times.year
        
        self.list = values.filter { entry -> Bool in
            //let time = Calendar.current.dateComponents([.month,.year], from: entry.date)
            return month == entry.month && year == entry.year
        }
    }
    
    private func manageTime(month: Int){
        var dateComponent = DateComponents()
        dateComponent.month = month
        currentDate = calendar.date(byAdding: dateComponent, to: currentDate) ?? Date()
    }
    
    private func updateTime(){
        
        let times =  self.calendar.dateComponents([.month,.year ], from: self.currentDate)
        let month = (times.month ?? 9) - 1
        let year = times.year ?? 2020
        
        self.month = calendar.monthSymbols[month]
        self.year = year.description
        
        AppDependencies.shared.salesRepo.getAll(month: month, year: year) { values in
            self.list = values
            self.updateTotal()
        }
    }
    
    private func updateTotal(){
        let value = self.list.filter({ $0.type == 1 }).map({$0.total}).reduce(0, +)
        self.total = self.getCurrency() + " \(value.format())"
        print("updateTotal: \(value)")
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
            currentMonth = monthInt - 1
            monthStr = Calendar.current.monthSymbols[monthInt-1]
        }
        
        let incomes1 = self.list.filter({
            $0.type == 0 && currentMonth == $0.month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes1))
        
        
        currentMonth = currentMonth - 1
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes2 = self.list.filter({
            $0.type == 0 && currentMonth == $0.month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes2))
        
        
        currentMonth = currentMonth - 2
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes3 = self.list.filter({
            $0.type == 0 && currentMonth == $0.month
        }).map({$0.total}).reduce(0, +)
        
        chart.append((monthStr,incomes3))
        
        currentMonth = currentMonth - 3
        monthStr = Calendar.current.monthSymbols[currentMonth]
        let incomes4 = self.list.filter({
            $0.type == 0 && currentMonth == $0.month
        }).map({$0.total}).reduce(0, +)
        chart.append((monthStr,incomes4))
        
        return ChartData(values: chart)
    }
    
}

struct FinanceView: View {
    @ObservedObject var viewModel: FinanceViewModel
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
                                Text("\(section.client)").foregroundColor(.black).font(.caption)
                                
                                if section.type == 1 {
                                    Text("\(section.location)").foregroundColor(.black).font(.caption)
                                    Text("Extra: \(section.extras)").foregroundColor(.black).font(.caption)
                                }
                                
                                Text("Day: \(section.day)").foregroundColor(.black).font(.caption)
                            }
                            
                            Spacer()
                            Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.total))").bold().font(.subheadline).foregroundColor(.black)
                            
                        }.padding()
                    }
                }
                
            }.onDelete(perform: self.deleteItem)
            
            
        }
        
        
        }.listStyle(GroupedListStyle()).onAppear {
            self.reloadValues()
        }
        
        
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
    
    private func reloadValues() {
        self.viewModel.load()
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
        return PieChartView(data: self.viewModel.pieData(), title: "Resumo",  dropShadow: false)
    }
    
    private func createBar() -> BarChartView {
        return BarChartView(data: self.viewModel.barData(), title: "Expenses", legend: "Quarterly", dropShadow: false)
    }
}

