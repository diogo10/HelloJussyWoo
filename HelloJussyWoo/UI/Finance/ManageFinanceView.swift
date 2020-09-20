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
    
    private var id: UUID = UUID()
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Info)
    
    
    func load(_ value: MoneyEntry?) {
        self.id = value?.id ?? UUID()
    }
    
    func save(name: String, total: String, type: Int) -> Bool {
        let finalTotal = Double(total) ?? 0.0
        
        if isValid(finalTotal: finalTotal, name: name) {
            do {
                let dictionary = ["id" : id,"name": name, "total": finalTotal,"type": type] as [String : Any]
                let moneyEntry = try MoneyEntry(from: dictionary)
                moneyEntryRepository.add(value: moneyEntry)
                return true
            } catch {
                print("Error: \(error)")
                return false
            }
        }
        
        
        return false
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
    @State var value: String = ""
    @ObservedObject var viewModel = ManageFinanceViewModel()
    @State private var pickerIndex = 0
    
    var body: some View {
      VStack {
            Form {
                Section(header: Text("General").fontWeight(.bold)) {
                    TextField("Type in the name", text: self.$name).keyboardType(.default).accentColor(.blue)
                    Picker(selection: self.$pickerIndex, label: Text("")) {
                        ForEach(0 ..< moneyEntryTypes.count) {
                            Text(moneyEntryTypes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Value").fontWeight(.bold)) {
                    TextField("Type in the value", text: self.$value).keyboardType(.numberPad).accentColor(.blue)
                }
                
                
                Section {
                    Button(action: {
                        if self.viewModel.save(name: self.name, total: self.value, type: self.pickerIndex) {
                            self.presentation.wrappedValue.dismiss()
                        } else {
                            print("Error")
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
            self.pickerIndex = self.data?.type ?? 0
        }
        
    }
}

struct ManageFinanceView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFinanceView()
    }
}
