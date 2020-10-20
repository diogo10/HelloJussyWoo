//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import Combine


struct ManageDatasheetView: View {
    @State var data: Datasheet?
    @ObservedObject var viewModel = ManageDatasheetViewModel()
    @State var nameBinding: String = ""
    @State private var stepper = 0
    
    var body: some View {
        
        ZStack { Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                Picker(selection: $stepper, label: Text("")) {
                    Text("Geral").tag(0)
                    Text("Ingredientes").tag(1)
                    Text("Valores").tag(2)
                }.pickerStyle(SegmentedPickerStyle()).padding()
                
                if self.stepper == 0 {
                    
                    Form {
                        Section(header: Text("Name").fontWeight(.bold).modifier(SectionHeaderStyle())) {
                            TextField("Type in the name", text: $nameBinding, onCommit: {
                                self.viewModel.updateName(value: nameBinding)
                            }).foregroundColor(.blue).font(.title)
                        }
                        
                    }
                    
                } else if self.stepper == 1 {
                    
                    List { Section(header: Header(viewModel: self.viewModel)) {
                        
                        ForEach(self.viewModel.selectedProducts) { section in
                            Item(product: section, viewModel: self.viewModel)
                        }.listRowBackground(Color.black)
                    }
                    }.listStyle(GroupedListStyle()).onAppear {
                        self.viewModel.load()
                    }.modifier(DismissingKeyboard())
                    
                } else if self.stepper == 2 {
                    SummaryView(viewModel: self.viewModel)
                }
               
            }.navigationBarTitle(Text("Datasheet")).onAppear {
                
                if self.viewModel.state == 0 {
                    self.nameBinding = self.data?.name ?? ""
                    self.viewModel.updateProductsFromData(list: self.data?.produtcs ?? [])
                    self.viewModel.id = self.data?.id ?? UUID().uuidString
                    self.viewModel.name = self.data?.name ?? ""
                    self.viewModel.lucro = self.data?.price ?? 0.0
                }
                
            }.banner(data: $viewModel.bannerData, show: $viewModel.showBanner)
        }
        
        
    }
}

// - MARK:

private struct Header: View {
    
    @State var yourBindingHere = ""
    @State var isLinkActive = false
    @State var viewModel: ManageDatasheetViewModel
    
    var body: some View {
        HStack{
            Text("Products").foregroundColor(.white).font(.headline).modifier(SectionHeaderStyle())
            NavigationLink(destination: MultiSelectionViewProvider(provider: viewModel.provideProductSelection()), isActive: $isLinkActive) {
                Button(action: {
                    self.isLinkActive = true
                    self.viewModel.updateState(value: 1)
                }) {
                    Image(systemName: "plus").foregroundColor(.white)
                }
            }
        }
        
    }
    
    
}


private struct Item: View {
    
    @State var yourBindingHere = ""
    @State var product: Product
    @State var viewModel: ManageDatasheetViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(product.name)").bold().font(.subheadline).foregroundColor(Color.white)
                    Text("\(product.unit) / \(product.price.format())").font(.caption).foregroundColor(Color.white)
                    Text("Custo Bruto: \(self.viewModel.calCustoBruto(product: product, qtUsada: yourBindingHere ).format())").font(.caption).foregroundColor(Color.white)
                }
                
                Spacer()
                
                VStack {
                    TextField("Qt usada", text: $yourBindingHere).keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100).onReceive(Just(yourBindingHere)) { value in
                        print(value)
                        self.viewModel.calculate(product: self.product, value: value)
                    }.multilineTextAlignment(.center)
                    
                }.padding(.leading,50).accentColor(.blue)
                
            }.padding()
        }.background(Color.black).onAppear {
            self.yourBindingHere = self.product.quantity.description
        }
        .background(Color.black)
    }
    
    
}

private struct SummaryView: View {
    @ObservedObject var viewModel: ManageDatasheetViewModel
    @State var yourPrice = ""
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        VStack{
            
            HStack {
                Text("Peso final").bold().font(.subheadline).padding(.leading,20).foregroundColor(.black)
                Spacer()
                Text("\(self.viewModel.pesoTotal.description)").font(.subheadline).padding(.trailing,20).foregroundColor(.black)
            }.opacity(self.viewModel.selectedProducts.isEmpty ? 0 : 1).padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            .background(Color.green).cornerRadius(6)
            
            
            VStack(alignment: .leading) {
                
                VStack {
                    
                    HStack {
                        Text("Custo Total Bruto").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.custoTotalSemImposto.format())").bold().font(.subheadline)
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                    HStack {
                        Text("Custo Total com Imposto").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.custoTotalComImposto.format())").bold().font(.subheadline)
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    
                    
                    HStack {
                        Text("Valor do (KG)").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.valorKilo.format())").bold().font(.subheadline)
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .background(Color.green).cornerRadius(6)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Preço de venda").bold().font(.subheadline).foregroundColor(.black).padding(.bottom,20)
                        Text("Margem de lucro").bold().font(.subheadline).foregroundColor(.black).padding(.top,20)
                        Text("Lucro").bold().font(.subheadline).foregroundColor(.black)
                    }.padding()
                    
                    Spacer()
                    VStack(alignment: .trailing){
                        
                        HStack{
                            
                            TextField("\(self.viewModel.lucro.format())", text: $yourPrice, onEditingChanged: { (editingChanged) in
                                if !editingChanged {
                                    print("TextField lost focus")
                                    self.viewModel.calculateLucro(valueString: yourPrice)
                                }
                            }, onCommit: {
                                print(yourPrice)
                                self.viewModel.calculateLucro(valueString: yourPrice)
                            }).keyboardType(.decimalPad).frame(width: 80).foregroundColor(.blue).font(.title)
                            .multilineTextAlignment(.trailing)
                            
                            
                        }.padding(.bottom,30)
                        
                        Text("\(self.viewModel.margemLucroPer)").font(.headline)
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.margemLucro.format())").font(.headline)
                    }.padding()
                    
                    
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                .background(Color.green).cornerRadius(6)
                
                
                
                //Save button
                VStack {
                    Button(action: {
                        print("save")
                        if self.viewModel.save(yourPrice: yourPrice) {
                            self.presentation.wrappedValue.dismiss()
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
                .padding(.top,50)
                
                
                
            }.frame(maxWidth: .infinity)
            
            .opacity(self.viewModel.selectedProducts.isEmpty ? 0 : 1)
        }.padding()
        .modifier(DismissingKeyboard())
    }
}


class ManageProductFormViewModel {
    
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


struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
            }
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
