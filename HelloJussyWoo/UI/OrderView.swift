//
//  OrderView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

struct OrderView: View {
    var placeholder: OrderData
    var body: some View {
        VStack {
            HStack {
                Text(placeholder.status.uppercased()).bold()
                Spacer()
                Text(placeholder.total)
            }.padding()
            HStack {
                Text("Created").bold()
                Spacer()
                Text(placeholder.createdAt)
            }.padding()
            HStack {
                Text("Client").bold()
                Spacer()
                Text(placeholder.clientName)
            }.padding()
            HStack {
                Text("Shipping cost").bold()
                Spacer()
                Text(placeholder.shippingTotal)
            }.padding()
            VStack {
                Text("Address").bold()
                Text(("\(placeholder.address) - \(placeholder.city) \(placeholder.postcode)"))
            }.padding()
            VStack {
                Text("Items").bold()
                Spacer()
                Text(placeholder.prettifyItems())
            }.padding()
            VStack {
                Text("Customer Note").padding()
                Text(placeholder.customerNote)
            }.padding()
        }
        .background(Color.green)
    }
}
let orders = [OrderData]()

struct OrderView_Previews: PreviewProvider {

    static var previews: some View {
        OrderView(placeholder: orders[0])
    }
}
