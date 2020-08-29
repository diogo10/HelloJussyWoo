//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ManageProductView: View {

    let title: String = "Ingredient"
    let subTitle: String = "Creating a new ingredient"
    var bgColor: Color = .blue

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                Ellipse()
                        .fill(self.bgColor)
                        .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
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

            VStack(alignment: .leading) {
                ManageProductViewForm().padding(.top, 30)
                Spacer()
            }
        }


        .background(Color.gray)
    }
}

struct ManageProductViewForm: View {
    @Environment(\.presentationMode) var presentation
    @State var value1: String = ""
    @State var value2: String = ""
    @State var value3: String = ""
    @State var value4: String = ""

    @State private var unitIndex = 0
    private var unitOptions: [String] = ["KG", "LT"]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("General")) {
                    TextField("Name", text: self.$value1).keyboardType(.default)

                    Picker(selection: self.$unitIndex, label: Text("Unit")) {
                        ForEach(0 ..< self.unitOptions.count) {
                            Text(self.unitOptions[$0])
                        }
                    }
                }

                Section(header: Text("Quantity in the purchased package")) {
                    TextField("Type in", text: self.$value2).keyboardType(.numberPad)
                }

                Section(header: Text("Amount Paid in each product")) {
                    TextField("Type in", text: self.$value2).keyboardType(.numberPad)
                }
                Section(header: Text("Amount used in the recipe")) {
                    TextField("Type in", text: self.$value4).keyboardType(.numberPad)
                }

                Section {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Save changes").foregroundColor(.blue)
                    }
                }
            }

        }

    }
}
