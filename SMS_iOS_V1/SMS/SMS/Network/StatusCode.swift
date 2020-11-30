//
//  StatusCode.swift
//  SMS
//
//  Created by 이현욱 on 2020/11/12.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

enum StatusCode {
    case OK
    case created
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case tooManyRequest
    case internalServerError
    case serviceUnavaliable
}
