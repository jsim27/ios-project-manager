//
//  ViewModel.swift
//  ProjectManager
//
//  Created by 이승재 on 2022/03/04.
//

import Foundation
import RxSwift
import RxRelay

class ViewModel {
    lazy var scheduleObservable = BehaviorRelay<[Schedule]>(value: [])
    let useCase: ScheduleUseCase
    lazy var itmesCount = scheduleObservable.map {
        $0.count
    }
    let addSchedule: AnyObserver<Void>
    let addedSchedule: BehaviorSubject<Schedule>

    init() {
        useCase = ScheduleUseCase(repository: DataRepository(dataSource: MemoryDataSource()))
        let disposeBag = DisposeBag()
        let adding = PublishSubject<Void>()
        addedSchedule = BehaviorSubject<Schedule>(value: Schedule(title: "추가됨", body: "ㅇㅇ", dueDate: Date(), progress: .doing))


        addSchedule = adding.asObserver()

        _ = useCase.fetch()
            .map { schedules in
                print(schedules)
                return schedules
            }
            .bind(to: scheduleObservable)

        adding
            .flatMap { self.useCase.create(Schedule(title: "추가", body: "추가", dueDate: Date(), progress: .doing))}
            .map { schedule in
                print(schedule)
                return schedule
            }
            .subscribe(onNext: addedSchedule.onNext)
            .disposed(by: disposeBag)

    }

    func example() {
        useCase.create(Schedule(title: "추가", body: "추가", dueDate: Date(), progress: .doing))
        scheduleObservable
            
    }


    }



