//
//  BaseViewModel.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 05/09/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import Foundation
import Data

class BaseViewModel {
    var isEditing: Bool = false
    
    func getCurrency() -> String {
        repoExpenses.getCurrency()
    }
}
