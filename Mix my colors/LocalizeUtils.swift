//
//  LocalizeUtils.swift
//  Mix my colors
//
//  Created by Ilya Paddubny on 09.02.2024.
//

import Foundation

import UIKit

class LocalizeUtils: NSObject {

    static let defaultLocalizer = LocalizeUtils()
    var appbundle = Bundle.main
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            appbundle = Bundle.main
            return
        }
        appbundle = Bundle(path: langPath)!
    }
    
    /// Translates a color name into a localized string.
    ///
    /// - Parameter colorName: The name of the color to be translated.
    /// - Returns: A localized string representing the translated color name.
    ///
    /// This function translates individual words of the color name using the app's
    /// localization settings. Each word is translated independently and then joined
    /// back together into a single string.
    ///
    /// **Usage Example:**
    ///
    /// ```swift
    /// let translatedColor = colorNameLocalizer("Red")
    /// print(translatedColor) // Output: "Красный"
    /// ```
    ///
    /// - Important: Make sure to specify the appropriate localization table where
    ///   the translations for color names are stored.
    func colorNameLocalizer(_ colorName: String) -> String {
        let translatedWords = colorName.components(separatedBy: " ").map {
            appbundle.localizedString(forKey: $0, value: "", table: nil)
        }
        
        return translatedWords.joined(separator: " ")
    }
    
    func stringFor(key: String) -> String {
        return appbundle.localizedString(forKey: key, value: "", table: nil)
    }
}
