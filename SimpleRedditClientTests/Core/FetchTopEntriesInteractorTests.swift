//
//  FetchTopEntriesInteractorTests.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 15.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class FetchTopEntriesInteractorTests: TestCase {

    private var fetchedEntries: [TopEntry] = []
    private var fetchError: Error?

    func testFetchShouldCallFetchOnGateway() {
        let gatewayMock = TopEntryGatewayMock()
        let interactor = makeInstance(gateway: gatewayMock)
        interactor.fetch()
        gatewayMock.verifyCalled(.fetch)
    }

    func testWhenFetchedTopEntriesThenShouldCallDidFetchOnOutput() {
        let gatewayStub = TopEntryGatewayFetchSuccessfullyStub()
        let interactor = makeInstance(gateway: gatewayStub)
        interactor.fetch()
        XCTAssertEqual(fetchedEntries, gatewayStub.items)
    }

    func testWhenFailedToFetchTopEntriesThenShouldCallFailedToFetchOnOutput() {
        let gatewayStub = TopEntryGatewayFetchFailingStub()
        let interactor = makeInstance(gateway: gatewayStub)
        interactor.fetch()
        XCTAssertNotNil(fetchError)
    }

    func testFetchMoreShouldCallFetchMoreOnGateway() {
        let gatewayMock = TopEntryGatewayMock()
        let interactor = makeInstance(gateway: gatewayMock)
        interactor.fetchMore()
        gatewayMock.verifyCalled(.fetchMore)
    }

    func testWhenFetchedMoreTopEntriesThenShouldCallDidFetchOnOutput() {
        let gatewayStub = TopEntryGatewayFetchMoreSuccessfullyStub()
        let interactor = makeInstance(gateway: gatewayStub)
        interactor.fetchMore()
        XCTAssertEqual(fetchedEntries, gatewayStub.items)
    }

    func testWhenFailedToFetchMoreTopEntriesThenShouldCallFailedToFetchOnOutput() {
        let gatewayStub = TopEntryGatewayFetchMoreFailingStub()
        let interactor = makeInstance(gateway: gatewayStub)
        interactor.fetchMore()
        XCTAssertNotNil(fetchError)
    }

    func testWhenIsFetchingMoreThenShouldIgnoreFetchMoreCalls() {
        let gatewayMock = TopEntryGatewayMock()
        let interactor = makeInstance(gateway: gatewayMock)
        interactor.fetchMore()
        gatewayMock.clear()
        interactor.fetchMore()
        gatewayMock.verifyWasNotCalled()
    }

    func testGivenIsFetchingMoreWhenCalledFetchThenCancelFetchMoreRequest() {
        let gatewayMock = TopEntryGatewayMock()
        let interactor = makeInstance(gateway: gatewayMock)
        interactor.fetchMore()
        gatewayMock.clear()
        interactor.fetch()
        gatewayMock.verifyCalled(.cancel)
    }

}

private extension FetchTopEntriesInteractorTests {

    func makeInstance(gateway: TopEntryGateway = TopEntryGatewayDummy()) -> FetchTopEntriesInteractor {
        let interactor = FetchTopEntriesInteractor(gateway)
        interactor.output = self
        return interactor
    }
}

extension FetchTopEntriesInteractorTests: FetchTopEntriesInteractorOutput {

    func didFetchTopEntries(_ topEntries: [TopEntry]) {
        fetchedEntries = topEntries
    }

    func failedToFetchTopEntries(with error: Error) {
        fetchError = error
    }
}
