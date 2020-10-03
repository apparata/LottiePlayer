//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI

struct ColorButton: View {
    
    let buttonColor: Color
    @Binding var color: Color
    
    init(_ buttonColor: Color, color: Binding<Color>) {
        self.buttonColor = buttonColor
        _color = color
    }
    
    var body: some View {
        Button { color = buttonColor } label: {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(Color(.sRGB, white: 0.0, opacity: 0.2))
                .background(Circle().foregroundColor(buttonColor))
                .frame(width: 16, height: 16)
        }.buttonStyle(CircleStyle())
    }
}

fileprivate struct CircleStyle: ButtonStyle {
    
    public init() {
        //
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
    }
}
