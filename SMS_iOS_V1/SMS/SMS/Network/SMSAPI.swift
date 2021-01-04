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
    case pwChange(_ currentPW: String, _ revision_pw: String)
    case myInfo
    case postOuting(_ startTime: Int, _ endTime: Int, _ place: String, _ reason: String, _ situation: String)
    case lookUpAllOuting
    case certainOutingInfo
    case lookUpOutingCard
    case startOuting
    case finishOuting
    case lookUpNotice
    case detailNotice
    case timetables(_ year: Int, _ month: Int, _ day: Int)
    case schedules(_ year: Int, _ month: Int)
    case checkNotReadNotice
    case location(_ keyWord: String)
}

extension SMSAPI {
    var baseURL: String {
        return "http://54.180.165.105:80"
    }
    
    var version: String {
        switch self {
        case .location:
            return ""
        default:
           return "/v1"
        }
    }
    
    var uuid: String {
        return UserDefaults.standard.value(forKey: "uuid") as! String
    }
    
    var outing_uuid: String {
        return UserDefaults.standard.value(forKey: "outing_uuid") as! String
    }
    
    var token: String {
        return UserDefaults.standard.value(forKey: "token") as! String
    }
    
    var announcement_uuid: String {
        return UserDefaults.standard.value(forKey: "announcement_uuid") as! String
    }
    
    var path: String {
        switch self {
        case .login:
            return  "/login/student"
        case .pwChange:
            return "/students/uuid/\(uuid)/password"
        case .myInfo:
            return "/students/uuid/\(uuid)"
        case .postOuting:
            return "/outings"
        case .lookUpAllOuting:
            return "/students/uuid/\(uuid)/outings"
        case .certainOutingInfo:
            return "/outings/uuid/\(outing_uuid)"
        case .lookUpOutingCard:
            return "/outings/\(outing_uuid)/card"
        case .startOuting:
            return "/outings/\(uuid)/outing"
        case .finishOuting:
            return "/outings/\(uuid)/finish-outing"
        case .lookUpNotice:
            return "/announcements/types/{type}"
        case .detailNotice:
            return "/announcements/uuid/\(announcement_uuid)"
        case .timetables(let year, let month, let day):
            return "/time-tables/years/\(year)/months/\(month)/days/\(day)"
        case .schedules(let year, let month):
            return "/schedules/years/\(year)/months/\(month)"
        case .checkNotReadNotice:
            return "students/uuid/\(uuid)/announcement-check"
        case .location(let keyWord):
            var newKeyWord = ""
            for v in keyWord.utf8 {
                newKeyWord += "%" + String(v, radix: 16, uppercase: true)
            }
            return "/naver-open-api/search/local?keyword=\(newKeyWord)"
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
            return .put
            
        case .myInfo,
             .checkNotReadNotice,
             .lookUpAllOuting,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .detailNotice,
             .timetables,
             .location,
             .schedules:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myInfo,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .detailNotice,
             .checkNotReadNotice,
             .lookUpAllOuting:

            return ["Authorization" : "Bearer " + token]
            
        case .postOuting,
             .location:
            return [
                "Authorization" : "Bearer " + token,
                //                "Request-Security": "",
                "Content-Type" : "application/json"
                ]
        default:
            return ["Content-Type" : "application/json"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .myInfo,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .detailNotice,
             .timetables,
             .location,
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
            
        case .pwChange(let currentPW, let revisionPW):
            return ["current_pw":currentPW, "revision_pw": revisionPW]
    
        case .postOuting(let startTime, let endTime, let place, let reason, let situation):
            return ["start_time": startTime, "end_time": endTime, "place": place, "reason": reason, "situation": situation]
        default:
            return nil
        }
    }
}
