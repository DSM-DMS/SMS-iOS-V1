import UIKit

import RxSwift
import RxCocoa
import FSCalendar
import Toast_Swift

class ScheduleViewController: UIViewController, Storyboarded {
    var value = false
    weak var coordinator: ScheduleCoordinator?
    let disposeBag = DisposeBag()
    private lazy var schedules: [Schedules]? = []
    private var preDict: [Date: [ScheduleData]] = [:]
    
    var date: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var dateForTable: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    @IBOutlet weak var combindTableView: UIView!
    @IBOutlet weak var tableUnderView: UIView!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    @IBOutlet weak var lineView: UIView!
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
        print(UIScreen.main.bounds.height)
        button.setImage(UIImage(named: "left"), for: .normal)
        let y = UIScreen.main.bounds.height > 800 ? calendarView.frame.minY + 5 + calendarView.frame.height / 4: calendarView.headerHeight
        button.frame = CGRect(x: UIScreen.main.bounds.midX - 8 - calendarView.frame.width / 4,
                              y: y,
                              width: 8,
                              height: 14)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right"), for: .normal)
        let y = UIScreen.main.bounds.height > 800 ? calendarView.frame.minY + 5 + calendarView.frame.height / 4: calendarView.headerHeight
        button.frame = CGRect(x: UIScreen.main.bounds.midX + calendarView.frame.width / 4,
                              y: y,
                              width: 8,
                              height: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        bindAction()
        tableViewBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSchedule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

//MARK- extension
extension ScheduleViewController {
    private func bindAction() {
        previousBtn.rx.tap
            .bind {
                let date = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind {
                let date = Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        changeViewBtn.rx.tap
            .bind {
                self.changeHidden(value: self.value)
                self.value.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    private func getSchedule() {
        self.date.map { nDate -> String in
            return globalDateFormatter(.month, nDate)
        }.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        .map { dateIntArr($0) }
        .debounce(.seconds(2), scheduler: MainScheduler.instance)
        .flatMap { arr -> Observable<ScheduleModel> in
            return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
        }.observeOn(MainScheduler.instance)
        .bind { schedules in
            self.schedules = schedules.schedules
            self.calendarView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    private func calendarSetting() {
        calendarView.today = nil
        calendarView.delegate = self
        calendarView.dataSource = self
        nextBtn.layer.zPosition = 1
        previousBtn.layer.zPosition = 1
        self.view.addSubviews([previousBtn, nextBtn])
        calendarView.placeholderType = .none
        calendarView.appearance.selectionColor = .white
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.titleSelectionColor = UIColor.black
        calendarView.appearance.headerDateFormat = formType.month.rawValue
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17)
        calendarView.register(DayCell.self, forCellReuseIdentifier: DayCell.NibName)
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
    }
    
    private func changeHidden(value: Bool) {
        previousBtn.isHidden = !value
        nextBtn.isHidden = !value
        calendarView.isHidden = !value
        combindTableView.isHidden = !value
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
    
    func dispatchViewHidden(_ view: UIView, _ time: Int = 10) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(time)) {
            view.isHidden = false
        }
    }
    
    func ascEvent() -> [Int] {
        var arrForEvent: [(Date, Int)] = []
        for i in 0..<schedules!.count {
            let start: Date = unix(with: (schedules![i].startTime / 1000) - 32400)
            arrForEvent.append((start, i))
        }
        arrForEvent.sort(by: <)
        var sortedIndex: [Int] = []
        for i in 0..<schedules!.count {
            sortedIndex.append(arrForEvent[i].1)
        }
        
        return sortedIndex
    }
}

extension ScheduleViewController: UITableViewDelegate {
    private func tableViewBind() {
        self.dateForTable.map { self.preDict[$0 + 32400] ?? [] }
            .skip(1)
            .filter {
                if $0.count == 0 {
                    self.view.makeToast("해당 날짜에는 일정이 없어요")
                }
                return true
            }
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                
                cell.scheduleDateLbl.text = schedule.detailDate
                cell.scheduleInfoLbl.text = schedule.detail
                switch schedule.place {
                case 1:
                    cell.scheduleColorView.backgroundColor = .customPurple
                case 2:
                    cell.scheduleColorView.backgroundColor = .customRed
                default:
                    cell.scheduleColorView.backgroundColor = .customYellow
                }
            }.disposed(by: disposeBag)
    }
    
    private func tableViewSetting() {
        tableView.delegate = self
        tableView.register(ScheduleCell.self)
        tableView.separatorStyle = .none
        tableUnderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableUnderView.layer.cornerRadius = 20
        combindTableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        combindTableView.addShadow(offset: CGSize(width: 0, height: 2), color: .gray, shadowRadius: 4, opacity: 1, cornerRadius: 10)
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        date.accept(calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: DayCell.NibName, for: date, at: position) as! DayCell
        cell.hiddenAll()
        let cnt = schedules?.count ?? 0
        
        for i in 0..<cnt {
            let start: Date = unix(with: (schedules![ascEvent()[i]].startTime / 1000) - 32400)
            let end: Date = unix(with: schedules![ascEvent()[i]].endTime / 1000)
            let detailDate: String = globalDateFormatter(.detailTime, start) + " - " + globalDateFormatter(.detailTime, end)
            
            
            if generateDateRange(from: start, to: end).contains(date + 32400) {
                handleEvent(cell, schedules![ascEvent()[i]].uuid, date + 32400, schedules![ascEvent()[i]].detail, detailDate)
            }
            cell.contentView.layer.shadowOpacity = 0
        }
        return cell
    }
    
    private func handleEvent(_ todayCell: DayCell, _ uuid: String, _ date: Date, _ detail: String, _ dateDetail: String) -> FSCalendarCell {
        let preEvent = preDict[date - 86400] ?? []
        
        if preEvent.count == 0 && todayCell.cellEvent.count == 0 {
            dispatchViewHidden(todayCell.event1View)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1))
            preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
            return todayCell
        }
        
        var eventPlace: Int = 0
        
        let todayEvent = preDict[date] ?? []
        
        if todayEvent.contains(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1)) {
            dispatchViewHidden(todayCell.event1View)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1))
            preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
            return todayCell
        }
        
        for yesterEventCnt in 0..<preEvent.count {
            if uuid == preEvent[yesterEventCnt].uuid {
                // 이어주기
                switch preEvent[yesterEventCnt].place {
                case 1:
                    dispatchViewHidden(todayCell.event1View)
                    eventPlace = 1
                case 2:
                    dispatchViewHidden(todayCell.event2View)
                    eventPlace = 2
                case 3:
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 3
                case 4:
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 4
                default: break
                }
            } else {
                if todayCell.cellEvent.count == 0 && preEvent.count == 0 || preEvent.contains(ScheduleData(uuid: uuid, date: date - 86400, detail: detail, detailDate: dateDetail, place: 1)){
                    dispatchViewHidden(todayCell.event1View)
                    eventPlace = 1
                } else if todayCell.cellEvent.count == 1 && preEvent.count == 1{
                    dispatchViewHidden(todayCell.event2View)
                    eventPlace = 2
                } else if todayCell.cellEvent.count == 2 && preEvent.count == 2 || todayCell.cellEvent.count == 2 && preEvent.count == 1 {
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 3
                } else if todayCell.cellEvent.count == 3 && preEvent.count == 4 {
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 4
                }
            }
        }
        todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: eventPlace))
        preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
        return todayCell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateForTable.accept(date)
        let cell = calendar.cell(for: date, at: monthPosition)
        
        let layer = cell!.contentView.layer
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.cornerRadius = cell!.fs_width / 10
        layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    // 이게 왜 안될까
    //        cell!.contentView.addShadow(offset: CGSize(width: 2, height: 2), color: .gray, shadowRadius: 2, opacity: 0.35, cornerRadius: cell!.fs_width / 10)
    //        cell!.contentView.layer.masksToBounds = false
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.cell(for: date, at: monthPosition)?.contentView.layer.shadowOpacity = 0
    }
}
