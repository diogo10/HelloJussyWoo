//
//  ViewExtensions.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

extension OrderView {
    
    func cornerView() -> some View {
        self.body.cornerRadius(7).shadow(radius: 10)
    }
}
