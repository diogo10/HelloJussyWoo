//
//  FinanceView.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI
import Data

struct FinanceView: View {
    
    var body: some View {
        
        List { Section(header: ListHeader().padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)), footer: ListFooter()) {
            Item()
            Item()
            Item()
            Item()
            Item()
            }
        }.listStyle(GroupedListStyle())
        
        
    }
}

struct Finance_Previews: PreviewProvider {
    
    static var previews: some View {
        FinanceView()
    }
}


// - MARK:

private struct Item: View {
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Payment").bold().font(.subheadline)
                    Text("14/07/2020").font(.caption)
                }
                
                Spacer()
                Text("R$ 45.00").bold().font(.subheadline)
            }.padding()
        }
    }
    
    
}

private struct ListHeader: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            //Image("avatar").resizable().frame(width: 50, height: 50)
            //  .clipShape(Circle())
            //  .shadow(radius: 10)
            
            HStack {
                VStack (alignment: .leading) {
                    Text("Current Balance").bold().font(.subheadline)
                    Text("February").font(.caption)
                }
                
                Spacer()
                VStack{
                    Text("$ 51254.00").bold().font(.title).foregroundColor(.blue)
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                
                VStack {
                    
                    Button(action: { }) {
                        Image("currency").frame(width: 50, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.red))
                    
                    Text("Expense").font(.caption)
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                
                
                VStack {
                    
                    Button(action: { }) {
                        Image("finance").frame(width: 50, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.green))
                    
                    Text("Income").font(.caption)
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                
                
                VStack {
                    
                    Button(action: { }) {
                        Image("linechart").frame(width: 50, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.orange))
                    
                    Text("Graph").font(.caption)
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 5))
            
            HStack {
                Text("Transations").bold().font(.subheadline)
                Spacer()
                Button(action: {
                    print("more filter")
                }) {
                    HStack {
                        Text("....").bold().foregroundColor(.blue)
                    }
                }
                
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            
        }
    }
}

struct ListFooter: View {
    var body: some View {
        Text("Total: R$ 45.00")
    }
}
