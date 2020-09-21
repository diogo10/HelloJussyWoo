//
//  PricingView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 02/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

struct PricingView: View {
    var body: some View {
        TabBgView(content: {
            PricingListView()
        }, title: "Pricing")
    }
}

class PricingViewModel {
    func load() -> [Pricing] {
        return pricingService.getAll()
    }
    
    func getCurrency() -> String {
        repoExpenses.getCurrency()
    }
}

struct PricingListView: View {
     private let viewModel = PricingViewModel()
    
    var body: some View {
        Text("todo")
    }
}

struct PricingListItemView: View {
    var section:Pricing
    var currency = ""
    var body: some View {
        VStack {
            
            Text("\(section.name)")
                .foregroundColor(.white)
                .font(.caption).padding(.top,10)
            
            
            Text("\(currency) \(section.total.format())")
                .foregroundColor(.white)
                .font(.title).padding(.top,30)
            
            Spacer()
            
        }.frame(width: 150, height: 150).background(Color.blue).cornerRadius(4)
    }
}

struct PricingView_Previews: PreviewProvider {
    static var previews: some View {
        PricingView()
    }
}
