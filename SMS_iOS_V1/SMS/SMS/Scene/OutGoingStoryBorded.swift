//
//  OutGoingStoryBorded.swift
//  SMS
//
//  Created by DohyunKim on 2020/11/20.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation
import UIKit

protocol OutGoingStoryBorded {
    
    static func instantiate() -> Self
}

extension OutGoingStoryBorded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "OutGoing", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
