//
//  UIView.swift
//  FlightRadar
//
//  Created by Jakub Nykiel on 25.05.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setView(hidden: Bool) {
        UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: { _ in
            self.isHidden = hidden
        }, completion: nil)
    }
}
