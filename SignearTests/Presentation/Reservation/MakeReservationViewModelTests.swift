//
//  MakeReservationViewModelTests.swift
//  signearTests
//
//  Created by 홍필화 on 2021/05/28.
//

import XCTest
import RxSwift
import RxTest
@testable import signear

class MakeReservationViewModelTests: XCTestCase {
    
    private var viewModel: MakeReservationViewModelType!
    private var useCase: MakeReservationUseCaseMock!
    private var schedular: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        useCase = MakeReservationUseCaseMock()
        viewModel = MakeReservationViewModel(useCase: useCase)
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
        let data: [MakeReservationModel] = [.init(date: "", startTime: "", endTime: "", center: "", location: "", requests: "", type: .offline)]
        useCase.result = .just(data)
        
        let testObserver = schedular.createObserver([MakeReservationModel].self)
        viewModel.outputs.reservation
            .drive(testObserver)
            .disposed(by: disposeBag)
        schedular.start()
        
        // when
        viewModel.inputs.fetchReservation()
        
        // then
        XCTAssertEqual(testObserver.events, [.next(0, data)], "fetch Rservations Calls Result")
        XCTAssertEqual(useCase.callsCount, 1, "fetch Rservations Calls Count")
    }
    
    func test_fetchReservations_error_emptyList() {
        // given
        useCase.result = .error(NSError(domain: "", code: 0, userInfo: nil))
        
        let testObserver = schedular.createObserver([MakeReservationModel].self)
        viewModel.outputs.reservation
            .drive(testObserver)
            .disposed(by: disposeBag)
        schedular.start()
        
        // when
        viewModel.inputs.fetchReservation()
        
        // then
        XCTAssertEqual(testObserver.events, [.next(0, [])], "fetch Rservations Calls Result")
        XCTAssertEqual(useCase.callsCount, 1, "fetch Rservations Calls Count")
    }

}

