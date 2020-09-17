//
//  OutGoingUIExtention.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingButtonUIExtention: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        
    }
    
}




class OutGoingContainerButtonUIExtention: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        
    }
}



class OutGoingViewUIExtention: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        
        
    }
}
