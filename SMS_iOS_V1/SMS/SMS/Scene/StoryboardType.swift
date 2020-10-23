//
//  StoryboardType.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/23.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

enum StoryBoard : String {
    
    case Login = "Login"
    
    case Schedule = "Schedule"
    
    case OutGoing = "OutGoing"
    case OutGoingApply = "OutGoingApply"
    case OutGoingCompleted = "OutGoingCompleted"
    case OutGoingLog = "OutGoingLog"
    case OutGoingNotice = "OutGoingNotice"
    case OutGoingDeed = "OutGoingDeed"
    case OutGoingAlert = "OutGoingAlert"
    case OutGoingPopDeed = "OutGoingPopDeed"
    
    case Notice = "Notice"
    case NoticeDetail = "NoticeDetail"
    
    case Mypage = "Mypage"
    case MypageChangePW = "MypageChangePW"
    case MypageChangePWAlert = "MypageChangePWAlert"
    case MypageIntroduceDev = "MypageIntroduceDev"
    case MypageLogout = "MypageLogout"
    
    
    
    
    var viewController : UIViewController {
        switch self  {
        
        case  .Login :
            return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
            
        case .Schedule :
            return UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
            
            
        case .OutGoing :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
        case .OutGoingApply :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingCompleted :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingLog :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingNotice :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingDeed :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingAlert :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .OutGoingPopDeed :
            return UIStoryboard(name: "OutGoing", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
            
            
        case .Notice :
            return UIStoryboard(name: "Notice", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .NoticeDetail :
            return UIStoryboard(name: "Notice", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
            
            
        case .Mypage :
            return UIStoryboard(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .MypageChangePW :
            return UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .MypageChangePWAlert :
            return UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .MypageIntroduceDev :
            return UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            
        case .MypageLogout :
            return UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
        }
        
    }
    
}


