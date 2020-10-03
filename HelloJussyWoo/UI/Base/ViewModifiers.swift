//
//  ViewModifiers.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 02/10/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                AnyView(content.textCase(.none))
            } else {
                content
            }
        }
    }
}
