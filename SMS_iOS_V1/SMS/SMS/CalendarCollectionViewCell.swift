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
    
    private var eventDotSize: CGFloat = 4.0
    weak var eventLayer: CAShapeLayer!

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var newDotView: UIView = {
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
        self.eventLayer.frame = self.contentView.bounds
        self.shapeLayer.frame = CGRect(x: self.contentView.center.x / 4,
                                       y: self.contentView.center.y / 10,
                                       width: 30,
                                       height: 30)
        
        eventIndicator.subviews.first?.alpha = 0.0 // hide dots of library
        
        let newDotRect = CGRect(x: (frame.width - eventDotSize) / 2,
                                y: eventDotSize / 2,
                                width: 6,
                                height: 6)

        newDotView.frame = newDotRect
        newDotView.backgroundColor = .white // {You want}
        newDotView.layer.cornerRadius = eventDotSize / 1.5
        eventIndicator.addSubview(newDotView)
        
        if selectionType == .middle {
            self.eventLayer.path = UIBezierPath(rect: self.eventLayer.bounds).cgPath
        } else if selectionType == .leftBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 4)).cgPath
        } else if selectionType == .rightBorder {
            self.eventLayer.path = UIBezierPath(roundedRect: self.eventLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.eventLayer.frame.width / 2, height: self.eventLayer.frame.width / 2)).cgPath
        } else if selectionType == .single {
            let diameter: CGFloat = min(self.eventLayer.frame.height, self.eventLayer.frame.width)
            self.eventLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2,
                                                               y: self.contentView.frame.height / 2 - diameter / 2,
                                                               width: diameter,
                                                               height: diameter)).cgPath
        } else if selectionType == .none {
            let diameter: CGFloat = min(self.eventLayer.frame.height, self.eventLayer.frame.width)
            self.eventLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2,
                                                               y: self.contentView.frame.height / 2 - diameter / 2,
                                                               width: 30,
                                                               height: 30)).cgPath
        }
    }
}
