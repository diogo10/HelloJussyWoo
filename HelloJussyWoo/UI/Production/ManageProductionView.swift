//
//  ManageProductionView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 28/08/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ManageProductionView: View {

    let title: String = "Datasheet"
    let subTitle: String = "Creating a new datasheet"
    var bgColor: Color = .blue

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                Ellipse()
                        .fill(self.bgColor)
                        .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.50)
                        .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                        .shadow(radius: 3)
                        .edgesIgnoringSafeArea(.all)

                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)

                        Text(self.subTitle)
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(Color.white)

                        Spacer()

                    }.padding(.leading, 25).padding(.top, 50)

                    Spacer()

                    VStack(alignment: .trailing) {

                        NavigationLink(destination: EmptyView()) {

                            Image(systemName: "save")
                                    .resizable()
                                    .padding(6)
                                    .frame(width: 28, height: 28)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .foregroundColor(.pink)
                        }


                        Spacer()

                    }.padding(.trailing, 20).padding(.top, 40)

                }.edgesIgnoringSafeArea(.all)

            }

            VStack {
                ManageProductionViewForm().padding(.leading, 20).padding(.top, 10)
                ManageProductionViewList().padding(.top, 40)
            }
        }

    }
}

struct ManageProductionViewForm: View {
    @State private var name = ""
    var body: some View {
        TextField("Type in the name", text: $name).keyboardType(.default).foregroundColor(.white)
    }
}


struct ManageProductionViewList: View {
    var body: some View {
        List {
            NavigationLink(destination: EmptyView()) {
                ManageProductionViewProducts()
            }
            ManageProductionViewProductsInfo(label: "Total in weight", caption: "0.00 KG")
            ManageProductionViewProductsInfo(label: "Yield (Final weight after ready)", caption: "0.00 KG")
            ManageProductionViewProductsInfo(label: "Total cost", caption: "R$ 0.00")
            ManageProductionViewProductsInfo(label: "Cost/Kilo", caption: "R$ 0.00")
            ManageProductionViewProductsInfo(label: "Sale price", caption: "R$ 0.00")
            ManageProductionViewProductsInfo(label: "Profit margin", caption: "R$ 0.00")
            ManageProductionViewProductsInfo(label: "Profit", caption: "R$ 0.00")
        }
    }
}

struct ManageProductionViewProducts: View {

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("0 Products").font(.caption)
                    Text("R$ 0,00").bold().font(.subheadline)
                }
                Spacer()
            }.padding()
        }
    }
}

struct ManageProductionViewProductsInfo: View {
    var label = ""
    var caption = ""
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(label).font(.caption)
                    Text(caption).bold().font(.subheadline)
                }
                Spacer()
            }.padding()
        }
    }
}

struct ManageProductionView_Previews: PreviewProvider {
    static var previews: some View {
        ManageProductionView()
    }
}
