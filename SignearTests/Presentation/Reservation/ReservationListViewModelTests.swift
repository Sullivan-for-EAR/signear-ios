//
//  ReservationListViewModelTests.swift
//  signearTests
//
//  Created by 신정섭 on 2021/05/22.
//

import XCTest
import RxSwift
import RxTest
@testable import signear

class ReservationListViewModelTests: XCTestCase {
    
    private var viewModel: ReservationListViewModelType!
    private var useCase: FetchReservationsUseCaseMock!
    private var schedular: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        useCase = FetchReservationsUseCaseMock()
        viewModel = ReservationListViewModel(useCase: useCase)
        schedular = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        useCase = nil
        viewModel = nil
        schedular = nil
        disposeBag = nil
    }
    
    func test_fetchReservations_success() {
        // given
        let data: [ReservationModel] = [.init(title: "title1", date: "data1", status: .unread),
                                        .init(title: "title2", date: "data2", status: .check),
                                        .init(title: "title3", date: "data3", status: .confirm)]
        useCase.result = .just(data)
        
        let testObserver = schedular.createObserver([ReservationModel].self)
        viewModel.outputs.reservations
            .drive(testObserver)
            .disposed(by: disposeBag)
        schedular.start()
        
        // when
        viewModel.inputs.fetchReservations()
        
        // then
        XCTAssertEqual(testObserver.events, [.next(0, data)], "fetch Rservations Calls Result")
        XCTAssertEqual(useCase.callsCount, 1, "fetch Rservations Calls Count")
    }
    
    func test_fetchReservations_error_emptyList() {
        // given
        useCase.result = .error(NSError(domain: "", code: 0, userInfo: nil))
        
        let testObserver = schedular.createObserver([ReservationModel].self)
        viewModel.outputs.reservations
            .drive(testObserver)
            .disposed(by: disposeBag)
        schedular.start()
        
        // when
        viewModel.inputs.fetchReservations()
        
        // then
        XCTAssertEqual(testObserver.events, [.next(0, [])], "fetch Rservations Calls Result")
        XCTAssertEqual(useCase.callsCount, 1, "fetch Rservations Calls Count")
    }

}
