//
//  ViewModelType.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/02.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

protocol ViewModelType {
    var input: Input { get }
    var output: Output { get }
    
    associatedtype Input
    associatedtype Output
}
