//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data
import Combine


class ManageDatasheetViewModel: BaseViewModel, ObservableObject {
    
    @Published var list: [Product] = []
    @Published var selectedProducts: [Product] = []
    private var provider:BaseSimpleProvider?
    
    @Published var name: String = ""
    @Published var margemLucro: Double = 0.0
    @Published var margemLucroPer: String = "0%"
    @Published var lucro: Double = 0.0
    @Published var pesoTotal: Double = 0.0
    @Published var valorKilo: Double = 0.0
    
    @Published var custoTotalComImposto: Double = 0.0
    @Published var custoTotalKiloComImposto: Double = 0.0
    
    @Published var custoTotalSemImposto: Double = 0.0
    @Published var custoTotalKiloSemImposto: Double = 0.0
    
    @Published var state: Int = 0
    
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Info)
    
    var id: UUID = UUID()
    var values = ["" : 0.0]
    
    func updateState(value: Int) {
        print("updateState: \(value)")
        self.state = value
    }
    
    func updateProductsFromData(list: [Product]) {
        self.selectedProducts = list
        list.forEach { item in
            calculate(product: item, value: item.quantity.description)
        }
        
    }
    
    func load()  {
        self.list =  productsRepository.getAll()
        setUpProvider()
        self.selectedProducts = getProductSelection()
    }
    
    func save(yourPrice: String) -> Bool {
        let finalPrice = Double(yourPrice) ?? self.lucro
        
        if name.isEmpty {
            bannerData.title = "Error"
            bannerData.detail = "Name can not be empty"
            bannerData.type = .Error
            showBanner = true
            return false
        }
        
        if finalPrice == 0.0 {
            bannerData.title = "Error"
            bannerData.detail = "Price can not be zero"
            bannerData.type = .Error
            showBanner = true
            return false
        }
        
        
        var finalProds: [Product] = []
        values.forEach { item in
            if var prod = selectedProducts.first(where: {$0.id.uuidString == item.key }) {
                prod.quantity = item.value
                finalProds.append(prod)
            }
        }
        
        
        do {
            let dictionary = ["id" : id,"name": name, "price": finalPrice,"products": finalProds] as [String : Any]
            let datasheet = try Datasheet(from: dictionary)
            datasheetRepository.add(value: datasheet)
            return true
        } catch {
            print("Error: \(error)")
            return false
        }
        
    }
    
    func productsNames() -> [String]  {
        return self.list.map { $0.name }
    }
    
    func provideProductSelection() -> BaseSimpleProvider {
        return self.provider!
    }
    
    func calCustoBruto(product: Product, qtUsada: String) -> Double {
        var result = 0.0
        
        if let qt = Double(qtUsada) {
            result = calculateCustoBruto(price: product.price, qtUsada: qt)
        }
        
        return result
    }
    
    private func calculateCustoBruto(price: Double,qtUsada: Double ) -> Double {
        let fator = 1000.0
        return (price * (qtUsada * 1000) ) / fator
    }
    
    func updateName(value: String) {
        self.name = value
    }
    
    func calculateLucro(valueString: String) {
    
        if let value = Double(valueString) {
            let per = ((value / self.custoTotalSemImposto) - 1) * 100
            self.margemLucroPer = "\(per.format())%"
            self.margemLucro = value - self.custoTotalSemImposto
        }
        
    }
    
    func calculate(product: Product, value: String) {
        updateValues(productId: product.id.uuidString, value: value)
        
        let kilos = getKiloProductsIds()
        
        
        var totalKilos = 0.0
        values.forEach { (key, value) in
            
            if kilos.contains(key){
                totalKilos = totalKilos + (value * 1000)
            }
            
        }
        
        self.custoTotalSemImposto = calCustoTotal()
        self.valorKilo =  self.custoTotalSemImposto / pesoTotal
        
        
        let impactInEachProduct = repoExpenses.impactInEachProduct() - 1
        let per = (self.custoTotalSemImposto / impactInEachProduct)
        self.custoTotalComImposto = self.custoTotalSemImposto + per
                                      
        self.pesoTotal = (totalKilos / 1000)
    
        let markup = 30
        self.lucro = self.custoTotalSemImposto + Double(markup)*custoTotalSemImposto/100;
        calculateLucro(valueString: "\(lucro)")
        
    }
    
    private func calCustoTotal() -> Double {
        var total = 0.0
        self.selectedProducts.forEach { item in
           
            if let real = values[item.id.uuidString] {
                total = total + calculateCustoBruto(price: item.price, qtUsada: real)
            }
        }
        
        return total
    }
    
    private func getKiloProductsIds() -> [String] {
        self.selectedProducts.filter { item in
            item.unit.uppercased() == "KG"
        }.map { $0.id.uuidString }
    }
    
    
    private func setUpProvider() {
        if provider == nil {
            self.provider = BaseSimpleProvider(list: productsNames())
        }
    }
    
    private func getProductSelection() -> [Product] {
        let selection = provider?.values ?? []
        return self.list.filter { selection.contains($0.name) }
    }
    
    private func updateValues(productId: String ,value: String){
        if let real = Double(value) {
            values[productId] = real
        }
    }
}

struct ManageDatasheetView: View {
    @State var data: Datasheet?
    @ObservedObject var viewModel = ManageDatasheetViewModel()
    @State var nameBinding: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            TextField("Type in the name", text: $nameBinding, onCommit: {
                print(nameBinding)
                self.viewModel.updateName(value: nameBinding)
            }).padding().foregroundColor(.blue).font(.title)
            
            
            List { Section(header: Header(viewModel: self.viewModel), footer: SummaryView(viewModel: self.viewModel)) {
                
                ForEach(self.viewModel.selectedProducts) { section in
                    Item(product: section, viewModel: self.viewModel)
                }
                }
            }.listStyle(GroupedListStyle()).onAppear {
                self.viewModel.load()
            }
            
            
            Spacer()
        }.navigationBarTitle(Text("Datasheet"))
        .onAppear {
            
            if self.viewModel.state == 0 {
                self.nameBinding = self.data?.name ?? ""
                self.viewModel.updateProductsFromData(list: self.data?.produtcs ?? [])
                self.viewModel.id = self.data?.id ?? UUID()
            }
           
        }
        .banner(data: $viewModel.bannerData, show: $viewModel.showBanner)
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
                    self.isLinkActive = true
                    self.viewModel.updateState(value: 1)
                }) {
                    Image(systemName: "plus").foregroundColor(.blue)
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
                    Text("\(product.name)").bold().font(.subheadline)
                    Text("\(product.unit) / \(product.price.format())").font(.caption)
                    Text("Custo Bruto: \(self.viewModel.calCustoBruto(product: product, qtUsada: yourBindingHere ).format())").font(.caption)
                }
                
                Spacer()
                
                VStack {
                    TextField("Qt usada", text: $yourBindingHere).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100).onReceive(Just(yourBindingHere)) { value in
                        print(value)
                        self.viewModel.calculate(product: self.product, value: value)
                    }.multilineTextAlignment(.center)
                    
                }.padding(.leading,50).accentColor(.blue)
                
            }.padding()
        }
        .onAppear {
            
            if self.viewModel.state == 0 {
                self.yourBindingHere = self.product.quantity.description
            }
            
        }
    }
    
    
}

private struct SummaryView: View {
    @ObservedObject var viewModel: ManageDatasheetViewModel
    @State var yourPrice = ""
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        VStack{
            
            if viewModel.selectedProducts.isEmpty {
                Image("lost").padding(.top,50)
                Text("Add products clicking on plus button").padding()
            }
            
            HStack {
                Text("Peso final").bold().font(.subheadline).padding(.leading,20)
                Spacer()
                Text("\(self.viewModel.pesoTotal.description)").font(.subheadline).padding(.trailing,20)
            }.opacity(self.viewModel.selectedProducts.isEmpty ? 0 : 1)
            
            
            VStack(alignment: .leading) {
                
                Text("Resumo").bold().foregroundColor(.black).font(.subheadline).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                VStack {
                    
                    HStack {
                        Text("Custo Total Bruto").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.custoTotalSemImposto.format())").bold().font(.subheadline)
                    }
                    
                    HStack {
                        Text("Custo Total com Imposto").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.custoTotalComImposto.format())").bold().font(.subheadline)
                    }
                    
                    
                    HStack {
                        Text("Valor do (KG)").bold().font(.subheadline)
                        Spacer()
                        Text("\(self.viewModel.valorKilo.format())").bold().font(.subheadline)
                    }.padding(.top,10)
                    
                }.padding(.bottom,20)
                
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
                            }).keyboardType(.numberPad).frame(width: 80).foregroundColor(.blue).font(.title)
                            .multilineTextAlignment(.trailing)
                            
                            
                        }.padding(.bottom,30)
              
                        Text("\(self.viewModel.margemLucroPer)").font(.headline)
                        Text("\(self.viewModel.getCurrency()) \(self.viewModel.margemLucro.format())").font(.headline)
                    }.padding()
                        
                    
                    
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
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
                .background(Color.blue)
                .cornerRadius(6)
                .padding(.top,50)
                
            
                
            }.frame(maxWidth: .infinity)
            
            .opacity(self.viewModel.selectedProducts.isEmpty ? 0 : 1)
        }
        
        
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
