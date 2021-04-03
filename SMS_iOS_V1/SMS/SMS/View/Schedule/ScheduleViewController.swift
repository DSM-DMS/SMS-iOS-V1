import UIKit

import RxSwift
import RxCocoa
import FSCalendar
import Toast_Swift

class ScheduleViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    var tableViewHeightConstraint: NSLayoutConstraint!
    weak var coordinator: ScheduleCoordinator?
    
    
    var Schedules: [ScheduleData] = []
    var value = false
    var date: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var dateForTable: BehaviorRelay<[ScheduleData]?> = BehaviorRelay(value: [ScheduleData(start: Date(), uuid: "", date: Date(), detail: "", detailDate: "", selected: false, place: 0)])
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
        var y = UIScreen.main.bounds.height > 800 ? calendarView.frame.minY + calendarView.frame.height / 3 : calendarView.headerHeight
        button.frame = CGRect(x: UIScreen.main.bounds.midX - 8 - calendarView.frame.width / 4,
                              y: y,
                              width: 8,
                              height: 14)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right"), for: .normal)
        let y = UIScreen.main.bounds.height > 800 ? calendarView.frame.minY + calendarView.frame.height / 3 : calendarView.headerHeight
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
        autoLogin()
        bindAction()
        tableViewBind()
    }
}

//MARK- extension
extension ScheduleViewController {
    func autoLogin() {
        if let ID = keyChain.get("ID"), let PW = keyChain.get("PW") { // 자동로그인 해두고 지금 들어온애
            let login: Observable<LoginModel> = SMSAPIClient.shared.networking(from: .login(ID, PW))
            login.subscribe { model in
                Account.shared.setUD(model.access_token, model.student_uuid)
                self.getSchedule()
                self.timeScheduleView.getTimeTable()
                self.bind()
            } onError: { (error) in
                if error as? StatusCode == StatusCode.internalServerError {
                    self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
                    self.calendarView.select(Date(), scrollToDate: false)
                    let cell = self.calendarView.cell(for: self.calendarView.selectedDate!, at: .current) as? DayCell
                    cell?.selectedDate(.selected)
                    self.dateForTable.accept(cell?.cellEvent)
                }
            }.disposed(by: disposeBag)
        } else if UserDefaults.standard.value(forKey: "token") != nil && UserDefaults.standard.value(forKey: "uuid") != nil && (keyChain.get("ID") == nil && keyChain.get("PW") == nil) {  // ud값은 있는데 keychain이 없는 경우, 로그인해서 들어왔는데 안한애
            bind()
            getSchedule()
            self.timeScheduleView.getTimeTable()
        } else { // ud값 없고 -> 로그인을 하지 않았고, keychian값 없고 -> 처음오는 애
            self.coordinator?.main()
        }
    }
    
    func bind() {
        let myInfo: Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        myInfo.filter { return $0.status == 200 }
        .bind { (model) in
            switch model.parent_status {
            case "CONNECTED": self.view.makeToast("학부모 계정과 연결되었습니다.", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            case "UN_CONNECTED": self.view.makeToast("현재 연결된 학부모 계정이 없습니다.", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            case "": print("Nothing")
            default: print("에러")
            }
        }.disposed(by: disposeBag)
        
        let asdasd: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
        asdasd.map { $0.announcements }
            .bind { data in
                data?.forEach({ (d) in
                    if d.noneReadingChecking() {
                        self.tabBarController?.viewControllers?[2].tabBarItem.setBadgeTextAttributes([.font: UIFont.systemFont(ofSize: 7), .foregroundColor: UIColor.red], for: .normal)
                    }
                })
            }.disposed(by: disposeBag)
    }
    
    private func bindAction() {
        Observable.merge(previousBtn.rx.tap.map { -1 }, nextBtn.rx.tap.map { +1 })
            .bind {
                let date = Calendar.current.date(byAdding: .month, value: $0, to: self.calendarView.currentPage)!
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
        .flatMap { arr -> Observable<ScheduleModel> in
            return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
        }.observe(on: MainScheduler.instance)
        .filter {
            if $0.status == 401 {
                self.coordinator?.main()
                return false
            }
            return true
        }.subscribe(onNext: { schedules in
            self.calendarSchedule(schedules.schedules!)
            self.calendarView.collectionView.reloadData {
                self.calendarView.select(Date(), scrollToDate: false)
                let cell = self.calendarView.cell(for: self.calendarView.selectedDate!, at: .current) as? DayCell
                cell?.selectedDate(.selected)
                self.dateForTable.accept(cell?.cellEvent)
            }
        }, onError: { (error) in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    private func calendarSetting() {
        calendarView.today = nil
        calendarView.delegate = self
        calendarView.dataSource = self
        nextBtn.layer.zPosition = 1
        previousBtn.layer.zPosition = 1
        self.view.addSubviews([previousBtn, nextBtn])
        calendarView.placeholderType = .none
        calendarView.appearance.selectionColor = .tabbarColor
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.titleSelectionColor = UIColor.black
        calendarView.appearance.borderRadius = 0.2
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
}

extension ScheduleViewController: UITableViewDelegate {
    private func tableViewBind() {
        self.dateForTable
            .filter({ (data) -> Bool in
                guard let _ = data else { return false}
                return true
            })
            .map { data -> [ScheduleData] in
                if data!.count == 0 {
                    return [ScheduleData(start: Date(), uuid: "", date: Date(), detail: "일정이 없습니다.", detailDate: "", selected: false, place: 100)]
                } else {
                    return data!
                }
            }
            .map { data -> [ScheduleData] in
                self.tableViewHeightConstraint.constant = CGFloat(data.count * 44) + 5
                return data
            }
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                cell.scheduleDateLbl.text = schedule.detailDate
                cell.scheduleInfoLbl.text = schedule.detail
                switch schedule.place {
                case 0:
                    cell.scheduleColorView.backgroundColor = .customPurple
                case 1:
                    cell.scheduleColorView.backgroundColor = .customRed
                case 2,3:
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
        tableUnderView.layer.cornerRadius = 20
        tableViewHeightConstraint = combindTableView.heightAnchor.constraint(equalToConstant: 47)
        tableViewHeightConstraint.isActive = true
        combindTableView.backgroundColor = .tabbarColor
        tableView.backgroundColor = .tabbarColor
        tableView.layer.cornerRadius = 4
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        combindTableView.addShadow(maskValue: false,
                                   offset: CGSize(width: 0, height: 2),
                                   shadowRadius: 4,
                                   opacity: 0.25,
                                   cornerRadius: 10)
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        date.accept(calendar.currentPage)
        Schedules.removeAll()
    }
    
    func calendarSchedule(_ schedules: [Schedules]?) {
        let cnt = schedules?.count ?? 0
        for i in 0..<cnt {
            let start: Date = unix(with: (schedules![i].startTime / 1000) - 32400)
            let end: Date = unix(with: schedules![i].endTime / 1000)
            let detailDate: String = globalDateFormatter(.detailTime, start) + " - " + globalDateFormatter(.detailTime, end)
            generateDateRange(from: start, to: end).forEach { date in
                let isStart = start + 32400 == date ? true : false
                Schedules.append(ScheduleData(start: start, uuid: schedules![i].uuid, date: date, detail: schedules![i].detail, detailDate: detailDate, selected: isStart, place: nil))
            }
        }
        Schedules.sort { (ScheduleData, ScheduleData1) -> Bool in
            ScheduleData.start < ScheduleData1.start
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: DayCell.NibName, for: date, at: position) as! DayCell
        cell.hiddenAll()
        cell.cellEvent.removeAll()
        cell.cellContinuedState.removeAll()
        cell.selectedDate(.normal)
        var place = 2
        Schedules.forEach { data in
            if data.contain(date + 32400) {
                if cell.cellEvent.count == 0 {
                    cell.event1View.isHidden = false
                    place = 0
                } else if cell.cellEvent.count == 1 {
                    cell.event2View.isHidden = false
                    place = 1
                } else if cell.cellEvent.count == 2 {
                    cell.event3View.isHidden = false
                    place = 2
                } else if cell.cellEvent.count == 3 {
                    place = 2
                }
                if data.selected {
                    cell.cellContinuedState.append(viewIdx(place))
                }
                cell.cellContinuedState.forEach({ (view) in
                    cell.selectedDate(.continued, view)
                })
                cell.cellEvent.append(ScheduleData(start: data.start, uuid: data.uuid, date: data.date, detail: data.detail, detailDate: data.detailDate, selected: data.selected, place: place))
            }
        }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition) as! DayCell
        self.dateForTable.accept(cell.cellEvent)
        cell.selectedDate(.selected)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition) as? DayCell
        cell?.selectedDate(.normal)
        
        cell?.cellContinuedState.forEach({ (view) in
            cell?.selectedDate(.continued, view)
        })
    }
    
    func viewIdx(_ idx: Int) -> View {
        switch idx {
        case 0:
            return .Event1
        case 1:
            return .Event2
        case 2:
            return .Event3
        default:
            return .Event4
        }
    }
}

