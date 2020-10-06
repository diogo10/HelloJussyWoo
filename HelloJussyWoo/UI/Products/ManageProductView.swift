//
//  ManageProductView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 05/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

class ManageProductViewModel: BaseViewModel {
    
    var model: Product?
    
    func load(id: String) {
        self.isEditing = false
        if let item = productsRepository.get(id: id){
            self.model = item
        }
    }
    
    func load(product: Product?) {
        self.model = product
    }
    
    func getUnit(product: Product?) -> Int {
        if let targetUnit = product?.unit {
            return units.firstIndex { $0 == targetUnit } ?? 0
        }
        return 0
    }
    
    func save(name: String, price: String, unit: String) -> Bool {
        
        if var item = model {
            item.name = name
            item.price = Double(price) ?? 0.0
            item.unit = unit
            return productsRepository.update(product: item)
        }
        return productsRepository.add(name: name, price: Double(price) ?? 0.0, unit: unit)
    }
    
}

struct ManageProductView: View {
    @Environment(\.presentationMode) var presentation
    @State var name: String = ""
    @State var price: String = ""
    @State private var unitIndex = 0
    @State private var state = 0
    @State var product: Product?
    
    private let viewModel = ManageProductViewModel()
    
    var body: some View {
        
        ZStack { Color.black.edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Form {
                    Section(header: Text("Name").fontWeight(.bold)) {
                        TextField("Type in the name", text: self.$name)
                            .keyboardType(.default).accentColor(.blue)
                    }
                    
                    Section(header: Text("Unidades").fontWeight(.bold)) {
                        Picker(selection: self.$unitIndex, label: Text("")) {
                            ForEach(0 ..< units.count) {
                                Text(units[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Price").fontWeight(.bold)) {
                        TextField("Type in the price", text: self.$price)
                            .keyboardType(.decimalPad).accentColor(.blue)
                    }
                    
                    
                    
                }
                
                VStack {
                    Button(action: {
                        print("save")
                        
                        if self.viewModel.save(name: self.name, price: self.price, unit: units[self.unitIndex]) {
                            self.presentation.wrappedValue.dismiss()
                        } else {
                            print("Error")
                        }
                        
                    }) {
                        Text("Save")
                            .padding()
                            .foregroundColor(.white)
                            .font(.title).frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(6)
                .padding()
                
                
                
            }.onAppear {
                self.viewModel.load(product: self.product)
                self.name = self.product?.name ?? ""
                self.price = self.product?.price.format() ?? ""
                self.unitIndex = self.viewModel.getUnit(product: self.product)
            }
        }
        
        .navigationBarTitle("")
    }
}

