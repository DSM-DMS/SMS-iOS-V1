import UIKit

import RxSwift
import RxCocoa
import FSCalendar

class ScheduleViewController: UIViewController, Storyboarded {
    var value = false
    weak var coordinator: ScheduleCoordinator?
    let disposeBag = DisposeBag()
    private lazy var schedules: [Schedules]? = []
    private var preDict: [Date: [ScheduleData]] = [:]
    
    private var date: Date = Date() {
        didSet(oldValue) {
            getSchedule()
        }
    }
    
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        button.frame = CGRect(x: calendarView.frame.midX - calendarView.frame.midX / 2, y: calendarView.frame.minY + 4, width: 8, height: 14)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right"), for: .normal)
        button.frame = CGRect(x: calendarView.frame.midX + calendarView.frame.midX / 2, y: calendarView.frame.minY + 4, width: 8, height: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        bindAction()
        bindUI()
        getSchedule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

//MARK- extension
extension ScheduleViewController {
    private func bindUI() {
        self.view.addSubviews([previousBtn, nextBtn])
        previousBtn.layer.zPosition = 1
        nextBtn.layer.zPosition = 1
    }
    
    private func bindAction() {
        previousBtn.rx.tap
            .bind { _ in
                self.date = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(self.date, animated: true)
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind { _ in
                self.date = Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(self.date, animated: true)
            }.disposed(by: disposeBag)
        
        changeViewBtn.rx.tap
            .bind { _ in
                self.value.toggle()
                self.changeHidden(value: self.value)
            }
            .disposed(by: disposeBag)
    }
    
    private func getSchedule() {
        Observable.just(globalDateFormatter(.month, self.date))
            .map { dateIntArr($0) }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { arr -> Observable<ScheduleModel> in
                return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
            }.bind { schedules in
                self.schedules = schedules.schedules
                self.calendarView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    private func tableViewSetting() {
        tableView.register(ScheduleCell.self)
        tableView.separatorStyle = .none
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.addShadow(offset: CGSize(width: 0, height: 3),
                            color: .black,
                            shadowRadius: 3,
                            opacity: 0.5,
                            cornerRadius: 17)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 어떻게 쓸지 고민
        cell.layer.masksToBounds = true
        let count = 2
        if count == 2 {
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == 1 {
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    private func calendarSetting() {
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendarView.today = nil
        calendarView.placeholderType = .none
        timeScheduleView.isHidden = true
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17)
        calendarView.appearance.headerDateFormat = formType.month.rawValue
        calendarView.register(DayCell.self, forCellReuseIdentifier: DayCell.NibName)
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func changeHidden(value: Bool) {
        previousBtn.isHidden = !value
        nextBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
    
    public func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
        let calendar = Calendar.current
        if startDate > endDate { return [] }
        var returnDates: [Date] = []
        var currentDate = startDate
        repeat {
            returnDates.append(currentDate + 32400)
            currentDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
        } while currentDate <= endDate
        return returnDates
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        for i in 0..<schedules!.count {
            let start: Date = unix(with: (schedules![i].startTime / 1000) - 32400)
            let end: Date = unix(with: schedules![i].endTime / 1000)
            print(generateDateRange(from: start, to: end))
            print(date + 32400)
            if generateDateRange(from: start, to: end).contains(date + 32400) {
                cell = handleEvent(cell as! DayCell , schedules![i].uuid, date + 32400, schedules![i].detail)
            }
        }
        
        //    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        // 짝수의 눌림때마다 2번눌러야 풀림 -> 해결해야함
        //        if firstDate == nil {
        //            firstDate = date
        //        } else {
        //            calendar.deselect(firstDate!)
        //            firstDate = nil
        //        }
        //        self.configureVisibleCells()
        //    }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: DayCell.NibName, for: date, at: position) as! DayCell
        return cell
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.date = calendar.currentPage
    }
    
    private func handleEvent(_ todayCell: DayCell, _ uuid: String, _ date: Date, _ detail: String) -> DayCell {
        let preEvent = preDict[date - 86400] ?? []
        
        for _ in 0..<todayCell.cellEvent.count {
            for yesterEventCnt in 0..<preEvent.count {
                if preEvent.count == 0 && todayCell.cellEvent.count == 0 {
                    todayCell.event1View.isHidden = false
                } else if uuid == preEvent[yesterEventCnt].uuid {
                    switch yesterEventCnt {
                    case 0:
                        todayCell.event1View.isHidden = false
                    case 1:
                        todayCell.event2View.isHidden = false
                    default:
                        todayCell.event3View.isHidden = false
                    }
                } else if todayCell.event1View.isHidden {
                    todayCell.event1View.isHidden = false
                } else if todayCell.event2View.isHidden {
                    todayCell.event2View.isHidden = false
                } else {
                    todayCell.event3View.isHidden = false
                }
            }
            
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail))
            preDict.updateValue(todayCell.cellEvent, forKey: date)
            return todayCell
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            Observable.just(preDict[date] ?? [])
                .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                    cell.scheduleDateLbl.text = "\(schedule.date)"
                    cell.scheduleInfoLbl.text = schedule.detail
                    switch idx {
                    case 1:
                        cell.scheduleColorView.backgroundColor = .customPurple
                    case 2:
                        cell.scheduleColorView.backgroundColor = .customRed
                    default:
                        cell.scheduleColorView.backgroundColor = .customYellow
                    }
                }.disposed(by: disposeBag)
        }
    }
}


