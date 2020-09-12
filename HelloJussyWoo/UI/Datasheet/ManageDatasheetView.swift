//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data


class ManageDatasheetViewModel: BaseViewModel, ObservableObject {
    
    @Published var list: [Product] = []
    @Published var selectedProducts: [Product] = []
    private var provider:BaseSimpleProvider?
    
    func load()  {
        self.list =  productsRepository.getAll()
        setUpProvider()
        self.selectedProducts = getProductSelection()
    }
    
    func productsNames() -> [String]  {
        return self.list.map { $0.name }
    }
    
    func provideProductSelection() -> BaseSimpleProvider {
        return self.provider!
    }
    
    private func setUpProvider() {
        if provider == nil {
            self.provider = BaseSimpleProvider(list: productsNames())
        }
    }

    private func getProductSelection() -> [Product] {
        let selection = provider?.list ?? []
        return self.list.filter { selection.contains($0.name) }
    }
}

struct ManageDatasheetView: View {
    var itemId: String
    @ObservedObject var viewModel = ManageDatasheetViewModel()
    
    var body: some View {
        NoIconBgView( content: {
            VStack(alignment: .leading) {
                
                List { Section(header: Header(viewModel: self.viewModel)) {
                    
                    ForEach(self.viewModel.selectedProducts) { section in
                        Item(product: section)
                    }
                    }
                }.listStyle(GroupedListStyle()).onAppear {
                    self.viewModel.load()
                }
                
                
                Spacer()
            }
        }, title: "Datasheet")
        
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        //self.viewModel.delete(index: indexSet.map({ it in
        //it
        //}))
        
    }
}

// - MARK:

private struct Header: View {
    
    @State var yourBindingHere = ""
    @State var isLinkActive = false
    @State var viewModel: ManageDatasheetViewModel
    
    var body: some View {
        HStack{
            Text("Products").foregroundColor(.black).font(.headline)
            NavigationLink(destination: MultiSelectionViewProvider(provider: viewModel.provideProductSelection()), isActive: $isLinkActive) {
                Button(action: {
                    print("asas")
                    self.isLinkActive = true
                }) {
                    Text("Add").foregroundColor(.blue).padding(.trailing,20).font(.headline)
                }
            }
        }
    }
    
    
}

private struct Item: View {
    
    @State var yourBindingHere = ""
    @State var product: Product
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(product.name)").bold().font(.subheadline)
                    Text("\(product.unit) / \(product.price.format())").font(.caption)
                }
                
                Spacer()
                
                VStack {
                    TextField("Qt usada", text: $yourBindingHere).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100)
                }.padding(.leading,50).accentColor(.blue)
                
            }.padding()
        }
    }
    
    
}

private struct SummaryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack (alignment: .leading) {
                    Text("Preço de venda").bold().font(.subheadline).foregroundColor(.black)
                    Text("78% de margem de lucro").font(.caption)
                    Text("R$ 8.50 de lucro").font(.caption)
                }
                
                Spacer()
                VStack{
                    Text("R$ 45.00").bold().font(.title).foregroundColor(.blue)
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            Text("Custos com imposto").bold().foregroundColor(.black).font(.subheadline).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                HStack {
                    Text("Peso Total da Receita").bold().font(.subheadline)
                    Spacer()
                    Text("1,00 kg").bold().font(.subheadline)
                }.padding(.top,10)
                
                HStack {
                    Text("Custo Total").bold().font(.subheadline)
                    Spacer()
                    Text("R$ 8.18").bold().font(.subheadline)
                }
                
                HStack {
                    Text("Custo/Kg").bold().font(.subheadline)
                    Spacer()
                    Text("R$ 8.18").bold().font(.subheadline)
                }
            }
            
            
            Text("Custos sem imposto").bold().foregroundColor(.black).font(.subheadline).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                HStack {
                    Text("Custo Total").bold().font(.subheadline)
                    Spacer()
                    Text("R$ 2.18").bold().font(.subheadline)
                }
                
                HStack {
                    Text("Custo/Kg").bold().font(.subheadline)
                    Spacer()
                    Text("R$ 4.18").bold().font(.subheadline)
                }
            }
            
            
            Text("Simulação de Lucro").bold().foregroundColor(.black).font(.subheadline).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            
            HStack{
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 4.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("10%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 5.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("20%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 6.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("30%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 7.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("40%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                
            }
            
            HStack{
                
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 8.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("50%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 9.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("60%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 10.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("70%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
                VStack {
                    
                    Button(action: { }) {
                        Text("R$ 11.18").bold().font(.subheadline).frame(width: 70, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("80%").font(.caption)
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
            }
        }
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
