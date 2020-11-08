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
        gatewayMock.verifyCalled(.fetch)
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
        let expectedViewModels = gatewayStub.items.map({ makeViewModel(for: $0) })
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

    func testWhenIsDisplayingAntepenultimateItemThenFetchMore() {
        let entries: [TopEntry] = [.stub0, .stub1, .stub2, .stub3]
        let (presenter, gatewayStub) = makeInstanceWithGatewayStub(entries: entries)
        gatewayStub.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        gatewayStub.verifyCalled(.fetchMore)
    }

    func testWhenIsDisplayingNotAnAntepenultimateItemThenDoNotFetchMore() {
        let entries: [TopEntry] = [.stub0, .stub1, .stub2, .stub3]
        let (presenter, gatewayStub) = makeInstanceWithGatewayStub(entries: entries)
        gatewayStub.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub0))
        presenter.willDisplayItem(makeViewModel(for: .stub2))
        presenter.willDisplayItem(makeViewModel(for: .stub3))
        gatewayStub.verifyWasNotCalled()
    }

    func testWhenFetchedMoreThenShouldCallShowOnView() {
        let viewMock = TopEntryListViewMock()
        let (presenter, gatewayStub) = makeInstanceWithGatewayStub(view: viewMock, entries: [.stub1, .stub2, .stub3])
        viewMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        viewMock.verifyCalled(.showItems)
        viewMock.verifyContains(gatewayStub.items.map({ makeViewModel(for: $0) }))
    }

    func testWhenFailedToFetchMoreThenShouldCallShowErrorMessage() {
        let viewMock = TopEntryListViewMock()
        let gatewayStub = TopEntryGatewayFetchMoreFailingStub([.stub1, .stub2, .stub3])
        let presenter = makeInstance(gateway: gatewayStub, view: viewMock)
        presenter.viewLoaded()
        viewMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        viewMock.verifyCalled(.showAlertWithMessage)
        viewMock.verifyMessageFormat(gatewayStub.error.localizedDescription)
    }

}

private extension TopListPresenterTests {

    func makeInstance(gateway: TopEntryGateway = TopEntryGatewayDummy(),
                      view: TopEntryListView = TopEntryListViewDummy()) -> TopEntryListPresenterImpl {
        let presenter = TopEntryListPresenterImpl(gateway)
        presenter.view = view
        return presenter
    }

    func makeInstanceWithGatewayStub(view: TopEntryListView = TopEntryListViewDummy(),
                                     entries: [TopEntry] = [.stub0]) -> (TopEntryListPresenterImpl, TopEntryGatewayFetchSuccessfullyStub) {
        let gatewayStub = TopEntryGatewayFetchSuccessfullyStub(entries)
        let presenter = makeInstance(gateway: gatewayStub, view: view)
        presenter.viewLoaded()
        return (presenter, gatewayStub)
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
