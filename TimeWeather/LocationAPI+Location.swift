//
//  LocationAPI+Location.swift
//  TimeWeather
//
//  Created by Pedro Altoe Costa on 15/5/17.
//  Copyright © 2017 Pedro Altoe Costa. All rights reserved.
//

import Foundation

extension Location {
    
    init?(json: [String: Any]) {
        guard let id = json[Keys.id] as? String,
            let description = json[Keys.description] as? String,
            let structuredFormatting = json[Keys.structuredFormatting] as? [String: Any],
            let mainText = structuredFormatting[Keys.mainText] as? String else { return nil }
        self.id = id
        self.description = description
        self.mainText = mainText.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    
    // MARK: - Private stuff
    
    private enum Keys {
        static let id = "id"
        static let description = "description"
        static let structuredFormatting = "structured_formatting"
        static let mainText = "main_text"
    }
    
}
