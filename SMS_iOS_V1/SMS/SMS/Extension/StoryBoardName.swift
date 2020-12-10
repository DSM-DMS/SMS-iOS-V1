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
    case noticeDetail
    case noticeMain
    case outGoingApply
    case outGoingLog
    case outGoingNotice
    case outGoingDeed
    case outGoingMain
    case myPageMain
    case myPageChangePW
    case myPageLogout
    case introduceDevlop
    case schedule
}

extension StoryBoardName {
    var name: String? {
        switch self {
        case .login,
             .tabbar:
            return "Login"
            
        case .noticeDetail,
             .noticeMain:
            return "Notice"
            
        case .outGoingApply,
             .outGoingLog,
             .outGoingNotice,
             .outGoingDeed,
             .outGoingMain:
            return "OutGoing"
            
        case .myPageMain,
             .myPageLogout,
             .myPageChangePW:
            return "MyPage"
            
        case .schedule:
            return "Schedule"
            
        default:
            return nil
        }
    }
}
