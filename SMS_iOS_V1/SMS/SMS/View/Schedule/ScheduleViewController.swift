import UIKit

import RxSwift
import RxCocoa
import FSCalendar
import Toast_Swift

class ScheduleViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    var value = false
    var date: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var tableViewHeightConstraint: NSLayoutConstraint!
    var dateForTable: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    weak var coordinator: ScheduleCoordinator?
    private var preDict: [Date: [ScheduleData]] = [:]
    private lazy var schedules: [Schedules]? = []
    
    @IBOutlet weak var combindTableView: UIView!
    @IBOutlet weak var tableUnderView: UIView!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    @IBOutlet weak var lineView: UIView!
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
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
        autoLogin()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        getSchedule()
//    }
}

//MARK- extension
extension ScheduleViewController {
    func autoLogin() {
//        UserDefaults.standard.removeObject(forKey: "token")
//        UserDefaults.standard.removeObject(forKey: "uuid")
//        keyChain.delete("ID")
        if let ID = keyChain.get("ID"), let PW = keyChain.get("PW") { // 자동로그인 해두고 지금 들어온애
            let login: Observable<LoginModel> = SMSAPIClient.shared.networking(from: .login(ID, PW))
            login.bind { model in
                UserDefaults.standard.setValue(model.access_token, forKey: "token")
                UserDefaults.standard.setValue(model.student_uuid, forKey: "uuid")
                self.getSchedule()
            }.disposed(by: disposeBag)
            bind()
        } else if UserDefaults.standard.value(forKey: "token") != nil && UserDefaults.standard.value(forKey: "uuid") != nil && (keyChain.get("ID") == nil && keyChain.get("PW") == nil) {  // ud값은 있는데 keychain이 없는 경우, 로그인해서 들어왔는데 안한애
            bind()
            getSchedule()
        } else { // ud값 없고 -> 로그인을 하지 않았고, keychian값 없고 -> 처음오는 애
            self.coordinator?.main()
        }
    }
    
    func bind() {
        let myInfo: Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        myInfo.filter {
            if $0.status == 401 {
                self.coordinator?.main()
                return false
            }
            return true
        }
        .bind { model in
            switch model.parent_status {
            case "CONNECTED": self.view.makeToast("학부모 계정과 연결되었습니다.")
            case "UN_CONNECTED": self.view.makeToast("현재 연결된 학부모 계정이 없습니다.")
            case "": print("성공")
            default: print("에러")
            }
        }.disposed(by: disposeBag)
    }
    
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
        }.observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
        .map { dateIntArr($0) }
        .debounce(.seconds(2), scheduler: MainScheduler.instance)
        .flatMap { arr -> Observable<ScheduleModel> in
            return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
        }.observe(on: MainScheduler.instance)
        .filter {
            if $0.status == 401 {
                self.coordinator?.main()
                return false
            }
            return true
        }
        .bind { schedules in
            self.schedules = schedules.schedules
            self.calendarView.reloadData()
            print(1)
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
            .map { data -> [ScheduleData] in
                if data.count == 0 {
                    return [ScheduleData(uuid: "", date: Date(), detail: "일정이 없습니다.", detailDate: "", place: 5)]
                } else {
                    return data
                }
            }
            .map { data -> [ScheduleData] in
                self.tableView.frame.size.height = CGFloat(data.count * 35)
                return data
            }
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                cell.scheduleDateLbl.text = schedule.detailDate
                cell.scheduleInfoLbl.text = schedule.detail
                switch schedule.place {
                case 1:
                    cell.scheduleColorView.backgroundColor = .customPurple
                case 2:
                    cell.scheduleColorView.backgroundColor = .customRed
                case 3,4:
                    cell.scheduleColorView.backgroundColor = .customYellow
                default:
                    cell.scheduleColorView.backgroundColor = .customBlack
                }
            }.disposed(by: disposeBag)
    }
    
    private func tableViewSetting() {
        tableView.delegate = self
        tableView.register(ScheduleCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableUnderView.layer.cornerRadius = 20
        combindTableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        
        combindTableView.addShadow(offset: CGSize(width: 0, height: 4),
                                   color: .gray,
                                   shadowRadius: 4,
                                   opacity: 1,
                                   cornerRadius: 10,
                                   corner: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
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
    
    @discardableResult
    private func handleEvent(_ todayCell: DayCell, _ uuid: String, _ date: Date, _ detail: String, _ dateDetail: String) -> FSCalendarCell {
        let preEvent = preDict[date - 86400] ?? []
        let todayEvent = preDict[date] ?? []
        
        if todayEvent.contains(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1)) {
            dispatchViewHidden(todayCell.event1View)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1))
            preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
            if !preEvent.contains(ScheduleData(uuid: uuid, date: date - 86400, detail: detail, detailDate: dateDetail, place: 1)) {
                todayCell.selectedDate(.continued, .Event1)
                todayCell.cellContinuedState.append(.Event1)
            }
            return todayCell
        }
        
        if preEvent.count == 0 && todayCell.cellEvent.count == 0 || preEvent.count == 1 && todayCell.cellEvent.count == 0 {
            dispatchViewHidden(todayCell.event1View)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 1))
            todayCell.selectedDate(.continued, .Event1)
            todayCell.cellContinuedState.append(.Event1)
            preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
            return todayCell
        }
        
        var eventPlace: Int = 0
        
        if todayCell.cellEvent.count == 1 && preEvent.count == 0 {
            self.dispatchViewHidden(todayCell.event2View)
            todayCell.selectedDate(.continued, .Event2)
            todayCell.cellContinuedState.append(.Event2)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: 2))
            preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
            return todayCell
        }
        
        for yesterEventCnt in 0..<preEvent.count {
            if uuid == preEvent[yesterEventCnt].uuid {
                if preEvent[yesterEventCnt].place == 1 {
                    dispatchViewHidden(todayCell.event1View)
                    eventPlace = 1
                } else if preEvent[yesterEventCnt].place == 2 {
                    dispatchViewHidden(todayCell.event2View)
                    eventPlace = 2
                } else if preEvent[yesterEventCnt].place == 3 {
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 3
                } else if preEvent[yesterEventCnt].place == 4 {
                    dispatchViewHidden(todayCell.event3View)
                    eventPlace = 4
                }
                todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: eventPlace))
                preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
                return todayCell
            }
        }
        if todayCell.cellEvent.count == 0 && preEvent.count == 1 || todayCell.cellEvent.count == 0 && preEvent.count == 2 || todayCell.cellEvent.count == 0 && preEvent.count == 3 {
            dispatchViewHidden(todayCell.event1View)
            todayCell.selectedDate(.continued, .Event1)
            todayCell.cellContinuedState.append(.Event1)
            eventPlace = 1
        } else if todayCell.cellEvent.count == 1 && preEvent.count == 0 || todayCell.cellEvent.count == 1 && preEvent.count == 1 || todayCell.cellEvent.count == 1 && preEvent.count == 2 || todayCell.cellEvent.count == 1 && preEvent.count == 3 {
            dispatchViewHidden(todayCell.event2View)
            todayCell.selectedDate(.continued, .Event2)
            todayCell.cellContinuedState.append(.Event2)
            eventPlace = 2
        } else if todayCell.cellEvent.count == 2 && preEvent.count == 0 || todayCell.cellEvent.count == 2 && preEvent.count == 2 || todayCell.cellEvent.count == 2 && preEvent.count == 1 || todayCell.cellEvent.count == 2 && preEvent.count == 3 {
            dispatchViewHidden(todayCell.event3View)
            todayCell.selectedDate(.continued, .Event3)
            todayCell.cellContinuedState.append(.Event3)
            eventPlace = 3
        } else if todayCell.cellEvent.count == 3 && preEvent.count == 4 {
            eventPlace = 4
        }
        
        todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, detailDate: dateDetail, place: eventPlace))
        preDict.updateValue(todayCell.todaySet(date, uuid), forKey: date)
        return todayCell
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateForTable.accept(date)
        let cell = calendar.cell(for: date, at: monthPosition) as! DayCell
        let layer = cell.contentView.layer
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.cornerRadius = cell.frame.width / 10
        layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        cell.selectedDate(.selected)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition) as! DayCell
        cell.selectedDate(.normal)
        for i in cell.cellContinuedState.indices {
            cell.selectedDate(.continued, cell.cellContinuedState[i])
        }
        cell.contentView.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
