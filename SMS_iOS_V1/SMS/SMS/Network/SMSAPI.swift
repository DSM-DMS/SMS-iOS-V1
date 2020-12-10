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

enum SMSAPI {
    case login(_ userId: String, _ pw: String)
    case pwChange(_ uuid: String)
    case myInfo(_ uuid: String)
    case postOuting
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

extension SMSAPI {
    var baseURL: String {
        return "http://10.220.158.111:8080"
    }
    
    var version: String {
        return "/v1"
    }
    
    var path: String {
        switch self {
        case .login:
            return  "/login/student"
        case .pwChange(let uuid):
            return "/auths/\(uuid)/password"
        case .myInfo(let uuid):
            return "/students/\(uuid)"
        case .postOuting:
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
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
             .postOuting,
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
    
    var header: HTTPHeaders {
        switch self {
        case .login,
             .pwChange,
             .myInfo:
            return ["Content-Type" : "application/json"]
        default:
            return ["Content-Type" : "application/json"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .myInfo,
             .lookUpAllOuting,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .detailNotice,
             .timetables,
             .schedules:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .login(let userId,let pw):
            return ["student_id":userId, "student_pw" : pw]
        case .certainOutingInfo(let uuid):
            return ["uuid": uuid]
        case .detailNotice(let uuid):
            return ["uuid": uuid]
        case .finishOuting(let uuid):
            return ["uuid": uuid]
        case.lookUpAllOuting(let uuid):
            return ["uuid": uuid]
        case.lookUpOutingCard(let uuid):
            return ["uuid": uuid]
        case .myInfo(let uuid):
            return ["uuid": uuid]
        case.pwChange(let uuid):
            return ["uuid": uuid]
        case .schedules(let uuid):
            return ["uuid": uuid]
        case .startOuting(let uuid):
            return ["uuid": uuid]
        case .timetables(let grade, let classes):
            return ["grade": grade, "classes": classes]
        default:
            return nil
        }
    }
}

