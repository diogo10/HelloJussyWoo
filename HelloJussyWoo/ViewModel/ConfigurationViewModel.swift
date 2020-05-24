//
//  ConfigurationViewModel.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import Foundation


import Foundation
import Combine
import Data

var repo = WooRepository()

class ConfigurationViewModel : ObservableObject{
    
    @Published var list = [OrderData]()
    @Published var isLoading: Bool = false
    
    func change(newIP: String) {
        repo.changeIP(newIp: newIP)
    }
}
