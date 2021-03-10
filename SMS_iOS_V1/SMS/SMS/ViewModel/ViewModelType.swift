//
//  ViewModelType.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/02.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
