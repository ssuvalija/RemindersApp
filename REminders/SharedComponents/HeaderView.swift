//
//  HeaderView.swift
//  REminders
//
//  Created by Selma Suvalija on 5/18/23.
//

import SwiftUI

struct HeaderView: View {
    var rightButtonTitle: String?
    var rightButtonAction: (() -> Void)?
    var title: String?
    var leftButtonTitle: String?
    var leftButtonAction: (() -> Void)?
    var disabledRightButton: (() -> Bool)?
    var disabledLeftButton: (() -> Bool)?
    var body: some View {
        HStack() {
            if let leftButtonTitle = leftButtonTitle, let leftButtonAction = leftButtonAction {
                Button(leftButtonTitle, action: {
                    leftButtonAction()
                })
                .disabled((disabledLeftButton ?? { return false })())
            }

            Spacer()
            
            Text(title ?? "")
            
            Spacer()
            
            if let rightButtonTitle = rightButtonTitle, let rightButtonAction = rightButtonAction {
                Button(rightButtonTitle, action: {
                    rightButtonAction()
                })
                .disabled((disabledRightButton ?? { return false })())
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .padding(16)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(rightButtonTitle: "Done", rightButtonAction: {})
    }
}
