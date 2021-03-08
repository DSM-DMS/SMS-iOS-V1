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
    case outGoingCompleted
    case outGoingMain
    case myPageMain
    case myPageChangePW
    case mypageChangePWAlert
    case myPageLogout
    case introduceDevlop
    case schedule
    case outGoingPopUp
    case locationAlert
    case outGoingAlert
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
             .outGoingCompleted,
             .outGoingPopUp,
             .locationAlert,
             .outGoingAlert,
             .outGoingMain:
            return "OutGoing"
            
        case .myPageMain,
             .myPageLogout,
             .myPageChangePW,
             .introduceDevlop,
             .mypageChangePWAlert:
            return "MyPage"
            
        case .schedule:
            return "Schedule"
            
        default:
            return nil
        }
    }
}
