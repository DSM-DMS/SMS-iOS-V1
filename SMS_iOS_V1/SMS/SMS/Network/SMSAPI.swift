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

extension API {
    var baseURL: String {
        return ""
    }
    
    var path: String {
        switch self {
        case .login:
            return  "/v1/login/student"
        case .pwChange(let uuid):
            return "/v1/auths/\(uuid)/password"
        case .myInfo(let uuid):
            return "/v1/students/\(uuid)"
        case .postOuting:
            return "/v1/outings"
        case .lookUpAllOuting(let uuid):
            return "/v1/students/\(uuid)/outings"
        case .certainOutingInfo(let uuid):
            return "/v1/outings/\(uuid)"
        case .lookUpOutingCard(let uuid):
            return "/v1/outings/\(uuid)/card"
        case .startOuting(let uuid):
            return "/v1/outings/\(uuid)/outing"
        case .finishOuting(let uuid):
            return "/v1/outings/\(uuid)/finish-outing"
        case .lookUpNotice:
            return "/v1/announcements"
        case .detailNotice(let uuid):
            return "/v1/announcements/\(uuid)"
        case .timetables(let grade, let classes):
            return "/v1/timetables/grades/\(grade)/classes/\(classes)"
        case .schedules(let month):
            return "/v1/schedules/monthes/\(month)"
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

