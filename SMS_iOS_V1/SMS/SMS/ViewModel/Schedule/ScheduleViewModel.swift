import Foundation
import RxSwift
import RxCocoa

class ScheduleViewModel {
    struct Input {
        let previousTapDriver: Driver<Void>
        let nextTapDriver: Driver<Void>
        let changeXibDriver: Driver<Void>
    }
    
    struct Output {
        //        let calendarDate: Single<Date>
    }
    
    func transform(_ input: Input) {
           
            
        
//        Observable.merge(input.previousTapDriver.map { Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)! },
//                         input.nextTapDriver.map {Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!}
//                            .map { b in
//                                self.calendarView.setCurrentPage(b, animated: true)
//                                self.yearLabel.text = globalDateFormatter(formType(rawValue: formType.month.rawValue)!).string(from: self.calendarView.currentPage)
//                            }
        //        .subscribe().disposed(by: disposeBag)
        ////        return Output(calendarDate: a)
        //    }
    }
}
