//
//  RouteProtocol.swift
//  REminders
//
//  Created by Selma Suvalija on 5/18/23.
//

import Foundation
import SwiftUI

public enum NavigationTranisitionStyle {
    case push
    case presentModally
    case presentFullscreen
}


public protocol Routable {
    
    associatedtype V: View

    var transition: NavigationTranisitionStyle { get }
    
    /// Creates and returns a view of assosiated type
    ///
    @ViewBuilder
    func view() -> V
}
