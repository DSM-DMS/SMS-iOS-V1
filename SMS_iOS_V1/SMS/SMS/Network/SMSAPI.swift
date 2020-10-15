//
//  APIService.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import Alamofire
import RxSwift
import RxCocoa

enum API {
    case login
    case pwChange(_ uuid: String)
    case myInfo(_ uuid: String)
    case applyOuting
    case lookUpAllOuting(_ uuid: String)
    case certainOutingInfo(_ uuid: String)
    case lookUpOutingCard(_ uuid: String)
    case startOuting(_ uuid: String)
    case finishOuting(_ uuid: String)
    case lookUpNotice
    case detailNotice(_ uuid: String)
    case timetables(_ grade: String, _ classes: String)
    case schedules(_ month: String)
}

extension API {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .login:
            return  "/login/student"
        case .pwChange(let uuid):
            return "/auths/\(uuid)/password"
        case .myInfo(let uuid):
            return "/students/\(uuid)"
        case .applyOuting:
            return "/outings"
        case .lookUpAllOuting(let uuid):
            return "/students/\(uuid)/outings"
        case .certainOutingInfo(let uuid):
            return "/outings/\(uuid)"
        case .lookUpOutingCard(let uuid):
            return "/outings/\(uuid)/card"
        case .startOuting(let uuid):
            return "/outings/\(uuid)/outing"
        case .finishOuting(let uuid):
            return "/outings/\(uuid)/finish-outing"
        case .lookUpNotice:
            return "/announcements"
        case .detailNotice(let uuid):
            return "/announcements/\(uuid)"
        case .timetables(let grade, let classes):
            return "/timetables/grades/\(grade)/classes/\(classes)"
        case .schedules(let month):
            return "/schedules/monthes/\(month)"
        }
        
        var method: HTTPMethod {
            switch self {
            case .login,
                 .applyOuting,
                 .startOuting,
                 .finishOuting:
                return .post
                
            case .pwChange:
                return .patch
                
            case .myInfo,
                 .lookUpAllOuting,
                 .certainOutingInfo,
                 .lookUpOutingCard,
                 .lookUpNotice,
                 .detailNotice,
                 .timetables,
                 .schedules:
                return .get
            }
        }
    }
}
