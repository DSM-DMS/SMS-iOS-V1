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
    
    private lazy var rect: UIView = {
        let view = UIView()
        return view
    }()

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.eventLayer = selectionLayer

        self.titleLabel.layer.zPosition = 2
        self.eventLayer.zPosition = 0
        self.shapeLayer.zPosition = 1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.eventLayer.frame = CGRect(x: self.contentView.bounds.minX, y: self.contentView.bounds.minY, width: 41, height: 30)
        
        if selectionType == .middle {
            self.eventLayer.path = UIBezierPath(rect: self.eventLayer.bounds).cgPath
        } else if selectionType == .leftBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.shapeLayer.frame.width / 2, height: self.shapeLayer.frame.width / 2)).cgPath
        } else if selectionType == .rightBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.shapeLayer.frame.width / 2, height: self.shapeLayer.frame.width / 2)).cgPath
        } else if selectionType == .single {
            let diameter: CGFloat = min(self.eventLayer.frame.height, self.eventLayer.frame.width)
            self.eventLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2 + 1,
                                                               y: self.contentView.frame.height / 2 - diameter / 2,
                                                               width: self.shapeLayer.frame.height,
                                                               height: self.shapeLayer.frame.width)).cgPath
        }
    }}
