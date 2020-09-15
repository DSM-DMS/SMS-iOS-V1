import FSCalendar
import Foundation
import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarCollectionViewCell: FSCalendarCell {

    weak var eventLayer: CAShapeLayer!

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.titleLabel.layer.insertSublayer(<#T##layer: CALayer##CALayer#>, below: <#T##CALayer?#>)
        
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.eventLayer = selectionLayer

        self.shapeLayer.zPosition = 1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.eventLayer.frame = self.contentView.bounds

        if selectionType == .middle {
            self.eventLayer.path = UIBezierPath(rect: self.eventLayer.bounds).cgPath
        } else if selectionType == .leftBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 2)).cgPath
        } else if selectionType == .rightBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 2)).cgPath
        } else if selectionType == .single {
            let diameter: CGFloat = min(self.eventLayer.frame.height, self.eventLayer.frame.width)
            self.eventLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
//    override func configureAppearance() {
//        super.configureAppearance()
//        self.titleLabel.textColor = UIColor.black
//    }
}

class DIYCalendarCell: FSCalendarCell {
    
    lazy var UInt = shapeLayer.zPosition
    weak var view: UIView!
    weak var eventLayer: CAShapeLayer!
    weak var selectionLayer: CAShapeLayer!
    
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView()
        self.contentView.insertSubview(view, at: 0)
        self.view = view
        
        let eventLayerSet = CAShapeLayer()
        let selectionLayerSet = CAShapeLayer()
        
        eventLayerSet.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(eventLayerSet, below: self.titleLabel!.layer)
        self.contentView.layer.insertSublayer(eventLayerSet, at: UInt32(UInt))
        self.eventLayer = eventLayerSet
        
        selectionLayerSet.fillColor = UIColor.init(displayP3Red: 83/255, green: 35/255, blue: 178/255, alpha: 1).cgColor
        selectionLayerSet.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayerSet, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayerSet
        
        self.shapeLayer.zPosition = CGFloat(integerLiteral: 1)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.view.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.eventLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.eventLayer.path = UIBezierPath(rect: self.eventLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.eventLayer.frame.height, self.eventLayer.frame.width)
            self.eventLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
            self.titleLabel.layer.zPosition = 0
        }
    }
}
