import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    var holidayArr = [String]()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var timeScheduleView: TimecScheduleXib!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var changeViewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        calendarView.delegate = self
        calendarView.dataSource = self
        timeScheduleView.isHidden = true
    }
    
    @IBAction func changeScheduleAndAcademicSchedule(_ sender: UIButton) {
        if sender.isSelected {
            self.changeHidden(value: true)
        } else {
            self.changeHidden(value: false)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func previousBtn(_ sender: UIButton) {
        let previous = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: previous)
        self.calendarView.setCurrentPage(previous, animated: true)
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        let next = Calendar.current.date(byAdding: .month, value: +1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: next)
        self.calendarView.setCurrentPage(next, animated: true)
    }
}

extension ScheduleViewController {
    func calendarSetting() {
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.eventOffset = CGPoint(x: 15, y: -35)
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        ca.weekdayTextColor = .black
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.headerHeight = 0
        calendarView.configureAppearance()
    }
    
    func tableViewSetting() {
        self.tableView.tableFooterView = UIView.init(frame: .infinite)
        self.tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setTableViewHeight(count: Int = 1) -> CGFloat {
        return CGFloat(Double(count) * 44.5)
    }
    
    func changeHidden(value: Bool) {
        leftBtn.isHidden = !value
        rightBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}

// 이벤트 어떻게 처리할지
// 날짜 한번 더 누르면 제거하기
// 연속으로 이어진 날짜 처리
// 탭바, 네비게이션바 있을떄 없을 때 뷰의 크기 차이




//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDate *selectedDate = [self.calculator dateForIndexPath:indexPath];
//    FSCalendarMonthPosition monthPosition = [self.calculator monthPositionForIndexPath:indexPath];
//    FSCalendarCell *cell;
//    if (monthPosition == FSCalendarMonthPositionCurrent) {
//        cell = (FSCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    }
//    else {
//        cell = [self cellForDate:selectedDate atMonthPosition:FSCalendarMonthPositionCurrent];
//        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
//        if (indexPath) {
//            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//        }
//    }
//    cell.selected = NO;
//    [cell configureAppearance];
//
//    [_selectedDates removeObject:selectedDate];
//    [self.delegateProxy calendar:self didDeselectDate:selectedDate atMonthPosition:monthPosition];
//    [self deselectCounterpartDate:selectedDate];
//
//}
