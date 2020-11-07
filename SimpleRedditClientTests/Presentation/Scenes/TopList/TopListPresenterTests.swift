//
//  TopListPresenterTests.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopListPresenterTests: TestCase {

    func testWhenViewLoadedThenShouldFetchTopEntities() {
        let gatewayMock = TopEntryGatewayMock()
        let presenter = makeInstance(gateway: gatewayMock)
        presenter.viewLoaded()
        gatewayMock.verifyCalled(.fetchMore)
    }

    func testWhenFetchedTopEntitiesThenShouldCallShowOnView() {
        let viewMock = TopEntryListViewMock()
        let gatewayStub = TopEntryGatewayFetchSuccessfullyStub()
        let presenter = makeInstance(gateway: gatewayStub, view: viewMock)
        presenter.viewLoaded()
        viewMock.verifyCalled(.showItems)
    }

    func testViewModelsContentFormatting() {
        let viewMock = TopEntryListViewMock()
        let gatewayStub = TopEntryGatewayFetchSuccessfullyStub()
        let presenter = makeInstance(gateway: gatewayStub, view: viewMock)
        presenter.viewLoaded()
        let expectedViewModels = [gatewayStub.entity].map({ makeViewModel(for: $0) })
        viewMock.verifyContains(expectedViewModels)
    }

    func testWhenFailedToFetchTopEntriesThenShouldShowErrorMessage() {
        let viewMock = TopEntryListViewMock()
        let gatewayStub = TopEntryGatewayFetchFailingStub()
        let presenter = makeInstance(gateway: gatewayStub, view: viewMock)
        presenter.viewLoaded()
        viewMock.verifyCalled(.showAlertWithMessage)
    }

    func testErrorFormatting() {
        let viewMock = TopEntryListViewMock()
        let gatewayStub = TopEntryGatewayFetchFailingStub()
        let presenter = makeInstance(gateway: gatewayStub, view: viewMock)
        presenter.viewLoaded()
        viewMock.verifyMessageFormat(gatewayStub.error.localizedDescription)
    }

}

private extension TopListPresenterTests {

    func makeInstance(gateway: TopEntryGateway = TopEntryGatewayDummy(),
                      view: TopEntryListView = TopEntryListViewDummy()) -> TopListPresenterImpl {
        let presenter = TopListPresenterImpl(gateway)
        presenter.view = view
        return presenter
    }
}

private extension TopListPresenterTests {

    func makeViewModel(for topEntry: TopEntry) -> TopEntryViewModel {
        let authorInfo = TopEntryAuthorInfoFormatter().infoString(for: topEntry)
        return TopEntryViewModel(id: topEntry.id,
                                 title: topEntry.title,
                                 info: authorInfo,
                                 thumbnail: nil,
                                 commentsCount: String(topEntry.commentsCount))
    }
}
