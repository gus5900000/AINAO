//
//  Theme.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import Foundation
import SwiftUI

///
///UI Related Consts
///
class ThemeManager: ObservableObject {
    @Published var isDark = true
}


struct Theme {
    
    static var unbleach: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.unbleach
        } else {
            return Consts.Theme2.unbleach
        }
    }
    static var color30: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.color30
        } else {
            return Consts.Theme2.color30
        }
    }
    
    static var color10: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.color10
        } else {
            return Consts.Theme2.color10
        }
    }
    
    static var color60: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.color60
        } else {
            return Consts.Theme2.color60
        }
    }
    
    static var fill: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.fill
        } else {
            return Consts.Theme2.fill
        }
    }
    
    static var frame: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.frame
        } else {
            return Consts.Theme2.frame
        }
    }
    
    static var appleGrey: Color {
        if ThemeManager().isDark {
            return Consts.Theme1.appleGrey
        } else {
            return Consts.Theme2.appleGrey
        }
    }
    

}


struct UnselectedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 150, height: 35) // Set the width and height here
            .background(
                Capsule()
                    .fill(Color.Tfill)
                    .overlay(
                        Capsule()
                            .stroke(Color.Tcolor30, lineWidth: 2) // Add a white stroke
                    )
            )
            .foregroundColor(.Tcolor60)
    }
    
}
struct SelectedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 150, height: 35) // Set the width and height here
            .background(
                Capsule()
                    .fill(Color.Tcolor10)
                    .overlay(
                        Capsule()
                            .stroke(Color.Tcolor30, lineWidth: 2) // Add a white stroke
                    )
            )
            .foregroundColor(.Tcolor60)
    }
    
}
