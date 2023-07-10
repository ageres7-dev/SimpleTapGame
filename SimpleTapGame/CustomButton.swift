//
//  CustomButton.swift
//  SimpleTapGame
//
//  Created by Sergey Dolgikh on 10.07.2023.
//

import SwiftUI

struct CustomButton: View {
    var body: some View {
        Button {
            
        } label: {
            Circle()
                .tint(.black)
                .foregroundColor(.red)
        }

    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
