//
//  ConfigurationView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct ConfigurationView: View {
    
    @ObservedObject var viewModel: ConfigurationViewModel
    
    @State private var ipText = ""
    
    var body: some View {
        Form {
            Section(footer: Text("Note: You might need to re-load data")) {
                
                VStack(alignment: .leading) {
                    Text("IP address")
                        .font(.callout)
                        .bold()
                    TextField("192.168....", text: $ipText).textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Consumer key")
                        .font(.callout)
                        .bold()
                    TextField("......", text: .constant("")) .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
                
                
                VStack(alignment: .leading) {
                    Text("Consumer secret")
                        .font(.callout)
                        .bold()
                    TextField("......", text: .constant("")).textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
                
                
                
                
            }
            
            Section {
                Button(action: {
                    self.viewModel.change(newIP: self.ipText)
                }) {
                    Text("Save changes")
                }
            }
        }
        
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(viewModel: ConfigurationViewModel())
    }
}
