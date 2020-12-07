//
//  StoryBoardName.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/07.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

enum StoryBoardName {
    case login
    case tabbar
}

extension StoryBoardName {
    var name: String {
        switch self {
        case .login,
             .tabbar:
            return "Login"
        default:
            return ""
        }
    }
}
