//
//  UIColorTransformer.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import Foundation
import UIKit

class UIColorTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else {
            return nil
        }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `UIColor` to `Data`")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        } catch {
            assertionFailure("Failed to transform `Data` to `UIColor`")
            return nil
        }
    }
}

extension UIColorTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: UIColorTransformer.self))
    
    public static func register() {
        let transformer = UIColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
