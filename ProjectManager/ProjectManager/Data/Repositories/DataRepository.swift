//
//  DataRepository.swift
//  ProjectManager
//
//  Created by 이승재 on 2022/03/04.
//

import Foundation
import RxSwift
import Network

final class DataRepository: Repository {

    var localDataSource: LocalDatabaseService
    var remoteDataSource: NetworkService
    var isConnected = true
    private let bag = DisposeBag()

    init(dataSource: LocalDatabaseService, remoteDataSource: NetworkService) {
        self.localDataSource = dataSource
        self.remoteDataSource = remoteDataSource
        self.binding()
    }

    private func binding() {
        NetworkCheck.shared.isConnected
            .subscribe(onNext: { isConnected in
                self.isConnected = isConnected
            })
            .disposed(by: self.bag)
    }

    func fetch() -> Single<[Schedule]> {
        if self.isConnected {
            return Single.zip(self.localDataSource.fetch(),
                       self.remoteDataSource.fetch()
            ) { local, remote -> Completable in
                let localId = Set(local.map { $0.id })
                let remoteId = Set(remote.map { $0.id })
                let difference1 = localId.subtracting(remoteId)
                let filltered1 = local.filter { difference1.contains($0.id) }
                let a = Completable.zip(filltered1.map {
                    self.remoteDataSource.create($0)
                })
                let difference2 = remoteId.subtracting(localId)
                let b = Completable.zip(difference2.map {
                    self.remoteDataSource.delete($0)
                })
                Completable.zip(a, b)

                return local
            }
        }
        return self.localDataSource.fetch()
    }

    func syncronize() {

    }

    // 네트워크 연결 (off -> on) : 동기화
    // 네트워크 연결이 되있는 상태에서도 지속적으로 remote의 변경사항이 local 반영되어야함

    func create(_ schedule: Schedule) -> Completable {
        if self.isConnected {
            return Completable.zip(
                self.localDataSource.create(schedule),
                self.remoteDataSource.create(schedule)
            )
        }

        return self.localDataSource.create(schedule)
    }

    func delete(_ scheduleID: UUID) -> Completable {
        if self.isConnected {
            return Completable.zip(
                self.localDataSource.delete(scheduleID),
                self.remoteDataSource.delete(scheduleID)
            )
        }

        return self.localDataSource.delete(scheduleID)
    }

    func update(_ schedule: Schedule) -> Completable {
        if self.isConnected {
            return Completable.zip(
                self.localDataSource.update(schedule),
                self.remoteDataSource.update(schedule)
            )
        }

        return self.localDataSource.update(schedule)
    }
}
