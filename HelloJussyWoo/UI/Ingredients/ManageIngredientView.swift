//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

struct ManageIngredientView: View {
    var itemId: String
    @State var isShowing: Bool = false
    
    
    var body: some View {
        LoadingView(isShowing: $isShowing ) {
            NoIconBgView( content: {
                VStack(alignment: .leading) {
                    ManageProductViewForm(itemId: self.itemId, isShowing: self.isShowing)
                    Spacer()
                }
            }, title: "Ingredient")
        }
    }
}



struct ManageProductViewForm: View {
    @Environment(\.presentationMode) var presentation
    @State var name: String = ""
    @State var value1: String = ""
    @State var value2: String = ""
    @State var value3: String = ""
    @State var value4: String = ""
    @State private var unitIndex = 0
    @State private var hasEdited = false
    
    private let viewModel = ManageProductViewModel()
    var itemId: String
    @State var isShowing: Bool

    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("General").fontWeight(.bold)) {
                    TextField("Name", text: self.$name).keyboardType(.default).accentColor(.blue)
                    
                    Picker(selection: self.$unitIndex, label: Text("Unit")) {
                        ForEach(0..<self.viewModel.unitOptions.count) {
                            Text(self.self.viewModel.unitOptions[$0])
                        }
                    }
                }
                
                Section(header: Text("Quantity in the purchased package").fontWeight(.bold)) {
                    TextField("Type in", text: self.$value1).keyboardType(.numbersAndPunctuation).accentColor(.blue)
                }
                Section(header: Text("Amount Paid in each product").fontWeight(.bold)) {
                    TextField("Type in", text: self.$value2).keyboardType(.numbersAndPunctuation).accentColor(.blue)
                }
                Section(header: Text("Amount used in the recipe").fontWeight(.bold)) {
                    TextField("Type in", text: self.$value3).keyboardType(.numbersAndPunctuation).accentColor(.blue)
                }
                Section(header: Text("Gross Cost").fontWeight(.bold)) {
                    TextField("Type in", text: self.$value4).keyboardType(.numbersAndPunctuation).accentColor(.blue)
                }
                
                Section {
                    Button(action: {
                        
                        
                        let unit = self.viewModel.unitOptions[self.unitIndex]
                        
                        self.viewModel.save(name: self.name, unit: unit, value1: self.value1, value2: self.value2, value3: self.value3, value4: self.value4)
                        
                        self.presentation.wrappedValue.dismiss()
                        
                        
                    }) {
                        Text("Save changes").foregroundColor(.blue)
                    }
                }
            }.foregroundColor(Color.black).background(Color.white)
        }.onAppear {
            if self.hasEdited == false {
                self.viewModel.load(id: self.itemId)
                self.name = self.viewModel.ingredient?.name ?? ""
                self.unitIndex = self.viewModel.getUnit()
                self.value1 = self.viewModel.ingredient?.packageQty.description ?? ""
                self.value2 = self.viewModel.ingredient?.amountPaidEachProduct.format() ?? ""
                self.value3 = self.viewModel.ingredient?.amountUsedInTheRecipe.format() ?? ""
                self.value4 = self.viewModel.ingredient?.grossCost.format() ?? ""
                self.hasEdited = true
            }
            
        }
    }
    
}


class ManageProductViewModel {
    
    var unitOptions: [String] = ["Kg=quilo", "Lt=litro",
                                 "Mç=maço", "Us=unidade", "Co=consumo de óleo",
                                 "Dz=dúzia", "Qb=quanto baste"]
    
    var ingredient: Ingredient?
    
    func load(id: String) {
        self.ingredient = ingredientsServiceRepository.get(id: id)
    }
    
    func getUnit() -> Int {
        let base = self.ingredient?.unit ?? "Kg=quilo"
        return unitOptions.firstIndex(of: base) ?? 0
    }
    
    func save(name: String, unit: String,value1: String, value2: String, value3: String, value4: String) {
        
        if var item = ingredient {
            item.name = name
            item.unit = unit
            item.packageQty = Int(value1) ?? 1
            item.amountPaidEachProduct = Double(value1) ?? 0.0
            item.amountUsedInTheRecipe = Double(value1) ?? 0.0
            item.grossCost = Double(value1) ?? 0.0
            print("updated: \( ingredientsServiceRepository.update(value: item))")
        }else {
            let ok = ingredientsServiceRepository.add(value1: name, value2: unit, value3: value1, value4: value2, value5: value3, value6: value4)
            print("save: \(ok)")
        }
        
        
    }
    
}
