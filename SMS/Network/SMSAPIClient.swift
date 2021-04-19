//
//  APIClient.swift
//  SMS
//
//  Created by 이현욱 on 2020/11/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire
import Toast_Swift

class SMSAPIClient {
    static let shared = SMSAPIClient()
    func networking<T:Codable>(from api: SMSAPI) -> Observable<T> {
        Observable.create { (obs) -> Disposable in
            if NetworkReachabilityManager()!.isReachable {
                let request = AF.request(URL(string: api.baseURL + api.version + api.path)!, method: api.method, parameters: api.parameter, encoding: api.encoding, headers: api.header).responseData { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        do {
                            let dataToUse: T = try JSONDecoder().decode(T.self, from: data)
                            return obs.onNext(dataToUse)
                        } catch(let error) {
                            return obs.onError(error)
                        }
                    case .failure(let error):
                        return obs.onError(error)
                    }
                }
                return Disposables.create {
                    request.cancel()
                }
            } else {
                obs.onError(StatusCode.internalServerError)
                return  Disposables.create()
            }
        }
    }
}


