//
// Created by Diogo Ribeiro on 29/08/2020.
// Copyright (c) 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data



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

                }.edgesIgnoringSafeArea(.all)
            }

            VStack(alignment: .leading) {
                ManageProductViewForm().padding(.top, 30)
                Spacer()
            }
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
    private var unitOptions: [String] = ["Kg=quilo", "Lt=litro",
                                         "Mç=maço", "Us=unidade", "Co=consumo de óleo",
                                         "Dz=dúzia", "Qb=quanto baste"]
    
    private let viewModel = ManageProductViewModel()

    var body: some View {
        VStack {
            Form {
                Section(header: Text("General").fontWeight(.bold)) {
                    TextField("Name", text: self.$name).keyboardType(.default).accentColor(.blue)

                    Picker(selection: self.$unitIndex, label: Text("Unit")) {
                        ForEach(0..<self.unitOptions.count) {
                            Text(self.unitOptions[$0])
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
                        let unit = self.unitOptions[self.unitIndex]
                        
                        self.viewModel.save(name: self.name, unit: unit, value1: self.value1, value2: self.value2, value3: self.value3, value4: self.value4)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Save changes").foregroundColor(.blue)
                    }
                }
            }

        }

    }
}


class ManageProductViewModel {

    func save(name: String, unit: String,value1: String, value2: String, value3: String, value4: String) {
        
    let ok = ingredientsServiceRepository.add(value1: name, value2: unit, value3: value1, value4: value2, value5: value3, value6: value4)
        print("save: \(ok)")
    }

}
