//
//  ManageDatasheetViewModel.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 06/10/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Combine
import Data

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
    
    var id: String = UUID().uuidString
    var values = ["" : 0.0]
    
    func updateState(value: Int) {
        print("updateState: \(value)")
        self.state = value
    }
    
    func updateProductsFromData(list: [Product]) {
        self.list = productsRepository.getAll()
        self.selectedProducts = list
        setUpProvider()
        self.provider?.values = list.map({ $0.name })
        list.forEach { item in
            calculate(product: item, value: item.quantity.description)
        }
    }
    
    func load() {
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
        //calculateLucro(valueString: "\(lucro)")
        
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
        return self.list.filter { selection.contains($0.name) }.map { item in
            var item = item
            if let real = values[item.id.uuidString] {
                item.quantity = real
            }
            return item
        }
        
    }
    
    private func updateValues(productId: String ,value: String){
        if let real = Double(value) {
            values[productId] = real
        }
    }
}
