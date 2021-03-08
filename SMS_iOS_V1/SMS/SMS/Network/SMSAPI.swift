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
import AesEverywhere

enum SMSAPI {
    case login(_ userId: String, _ pw: String)
    case pwChange(_ currentPW: String, _ revision_pw: String)
    case myInfo
    case postOuting(_ startTime: Int, _ endTime: Int, _ place: String, _ reason: String, _ situation: String)
    case lookUpAllOuting(_ start: Int, _ count: Int)
    case certainOutingInfo
    case lookUpOutingCard(_ uuid: String)
    case lookUpNotice
    case detailNotice
    case outingAction(_ code: String)
    case timetables(_ year: Int, _ month: Int, _ day: Int)
    case schedules(_ year: Int, _ month: Int)
    case checkNotReadNotice
    case location(_ keyWord: String)
    case certificationNumber(_ number: String)
    case register(_ code: Int, _ ID: String, _ PW: String)
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
    
    var securityKey: String {
        let SECURITY_BASE_PLAIN = "SMS_security:\(Date().timeIntervalSince1970)"
        let SECURITY_PASS_PHRASE = "pdpdlcl14kfkdgody!shfo7owhgdms~^"
        return try! AES256.encrypt(input: SECURITY_BASE_PLAIN, passphrase: SECURITY_PASS_PHRASE)
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
        case .lookUpAllOuting(let start, let count):
            return "/students/uuid/\(uuid)/outings?count=\(count)&start=\(start)"
        case .certainOutingInfo:
            return "/outings/uuid/\(outing_uuid)"
        case .lookUpOutingCard:
            return "/outings/uuid/\(outing_uuid)/card"
        case .outingAction(let code):
            return "/outings/uuid/\(outing_uuid)/actions/\(code)"
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
            for idx in keyWord.utf8 {
                newKeyWord += "%" + String(idx, radix: 16, uppercase: true)
            }
            return "/naver-open-api/search/local?keyword=\(newKeyWord)"
        case .certificationNumber(let number):
            return "/students/auth-code/\(number)"
        case .register:
            return "/students/with-code"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
             .postOuting,
             .outingAction,
             .register:
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
             .schedules,
             .certificationNumber:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .myInfo,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .outingAction,
             .detailNotice,
             .checkNotReadNotice,
             .schedules,
             .timetables,
             .lookUpAllOuting:
            return [
                "Authorization" : "Bearer " + token,
                "Request-Security": securityKey
            ]
        case .postOuting,
             .location:
            return [
                "Authorization" : "Bearer " + token,
                "Request-Security": securityKey,
                "Content-Type" : "application/json"
            ]
        default:
            return [
                "Content-Type" : "application/json",
                "Request-Security": securityKey
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .myInfo,
             .certainOutingInfo,
             .lookUpOutingCard,
             .lookUpNotice,
             .detailNotice,
             .outingAction,
             .timetables,
             .location,
             .schedules,
             .certificationNumber:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .login(let userId,let pw):
            return [
                "student_id":userId,
                "student_pw" : pw
            ]
            
        case .pwChange(let currentPW, let revisionPW):
            return [
                "current_pw":currentPW,
                "revision_pw": revisionPW
            ]
            
        case .postOuting(let startTime, let endTime, let place, let reason, let situation):
            return [
                "start_time": startTime,
                "end_time": endTime,
                "place": place,
                "reason": reason,
                "situation": situation
            ]
            
        case .register(let code, let id, let pw):
            return [
                "auth_code": code,
                "student_id": id,
                "student_pw": pw
            ]
            
        default:
            return nil
        }
    }
}
