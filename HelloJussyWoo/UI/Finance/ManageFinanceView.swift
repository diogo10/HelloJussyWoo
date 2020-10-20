//
//  ManageFinanceView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 20/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class ManageFinanceViewModel: BaseViewModel, ObservableObject {
    
    private var id: String = ""
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Info)
    
    
    func load(_ value: MoneyEntry?) {
        self.id = value?.id ?? ""
    }
    
    func save(dic: [String : Any], result: @escaping (Bool) -> Void) {
        var dic = dic
        let finalTotal = Double(dic["total"] as? String ?? "0.0") ?? 0.0
        let flag = isValid(finalTotal: finalTotal, name: dic["name"] as! String)
        
        if flag {
            
            dic["id"] = id
            dic["total"] = finalTotal
            dic["entry"] = Double(dic["entry"] as? String ?? "0.0") ?? 0.0
            dic["quantity"] = Double(dic["quantity"] as? String ?? "0.0") ?? 0.0
            
            let date = dic["entry"] as? Date ?? Date()
            dic = manageTime(dic: dic, date: date)
            
            let moneyEntry = MoneyEntry(data: dic)
            AppDependencies.shared.salesRepo.addOrUpdate(value: moneyEntry, result: result)
        } else {
            result(false)
        }
        
    }
    
    private func manageTime(dic: [String : Any],date: Date) -> [String : Any] {
        var dic = dic
        
        let times =  Calendar.current.dateComponents([.month,.year,.day], from: date)
        let month = (times.month ?? 9) - 1
        let year = times.year
        let day = times.day
        
        dic["month"] = month
        dic["year"] = year
        dic["day"] = day
        
        return dic
    }
    
    private func isValid(finalTotal: Double, name: String) -> Bool {
        
        if name.isEmpty {
            bannerData.title = "Error"
            bannerData.detail = "Name can not be empty"
            bannerData.type = .Error
            showBanner = true
            return false
        }
        
        if finalTotal == 0.0 {
            bannerData.title = "Error"
            bannerData.detail = "Value can not be zero"
            bannerData.type = .Error
            showBanner = true
            return false
        }
        
        return true
    }
    
}

struct ManageFinanceView: View {
    @State var data: MoneyEntry?
    @Environment(\.presentationMode) var presentation
    @State var name: String = ""
    @State var client: String = ""
    @State var extras: String = ""
    @State var location: String = ""
    @State var phone: String = ""
    @State var value: String = ""
    @State var kg: String = ""
    @State var entry: String = ""
    @ObservedObject var viewModel = ManageFinanceViewModel()
    @State private var pickerIndex = 0
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("General").fontWeight(.bold)) {
                    
                    Picker(selection: self.$pickerIndex, label: Text("")) {
                        ForEach(0 ..< moneyEntryTypes.count) {
                            Text(moneyEntryTypes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if self.pickerIndex == 1 {
                        TextField("Client name", text: self.$client).keyboardType(.default).accentColor(.blue)
                        TextField("Type in the reference name", text: self.$name).keyboardType(.default).accentColor(.blue)
                        TextField("Extras", text: self.$extras).keyboardType(.default).accentColor(.blue)
                        TextField("Location", text: self.$location).keyboardType(.default).accentColor(.blue)
                        TextField("Phone", text: self.$phone).keyboardType(.default).accentColor(.blue)
                    } else {
                        TextField("Type in the reference name", text: self.$name).keyboardType(.default).accentColor(.blue)
                    }
                    
                    
                }
                
                Section(header: Text("Values").fontWeight(.bold)) {
                    TextField("Type in the value", text: self.$value).keyboardType(.decimalPad).accentColor(.blue)
                    
                    if self.pickerIndex == 1 {
                        TextField("KG", text: self.$kg).keyboardType(.decimalPad).accentColor(.blue)
                        TextField("Entry", text: self.$entry).keyboardType(.decimalPad).accentColor(.blue)
                           .modifier(DismissingKeyboard())
                    }
                   
                }
                
                
                Section {
                    Button(action: {
                        
                        var dictionary = ["name": self.name, "total": self.value,"type": self.pickerIndex] as [String : Any]
                        dictionary.updateValue(self.extras, forKey: "extras")
                        dictionary.updateValue(self.location, forKey: "location")
                        dictionary.updateValue(self.phone, forKey: "phone")
                        dictionary.updateValue(self.client, forKey: "client")
                        dictionary.updateValue(self.entry, forKey: "entry")
                        dictionary.updateValue(self.kg, forKey:"quantity")
                        dictionary.updateValue(Date(), forKey:"date")
                        
                        self.viewModel.save(dic: dictionary) { result in
                            
                            if result {
                                self.presentation.wrappedValue.dismiss()
                            } else {
                                print("Error")
                            }
                        }
                        
                    }) {
                        Text("Save changes").foregroundColor(.blue)
                    }
                }
            }.foregroundColor(Color.black).background(Color.white)
            
            
            .navigationBarTitle(Text("Entry"))
           
        }.onAppear {
            self.viewModel.load(self.data)
            self.name = self.data?.name ?? ""
            self.value = self.data?.total.description ?? ""
            self.entry = self.data?.entry.description ?? ""
            self.kg = self.data?.kg.description ?? ""
            self.client = self.data?.client ?? ""
            self.location = self.data?.location ?? ""
            self.extras = self.data?.extras ?? ""
            self.phone = self.data?.phone ?? ""
            self.pickerIndex = self.data?.type ?? 0
        }
        
    }
}

struct ManageFinanceView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFinanceView()
    }
}
