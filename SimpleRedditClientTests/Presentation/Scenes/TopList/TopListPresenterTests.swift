//
//  TopListPresenterTests.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopListPresenterTests: TestCase {

    private let topEntries: [TopEntry] = [.stub0, .stub1, .stub2, .stub3]
    private let error = TestError.default

    func testWhenViewLoadedThenShouldFetchTopEntities() {
        let (presenter, interactorMock) = makeInstanceWithInteractorMock()
        presenter.viewLoaded()
        interactorMock.verifyCalled(.fetch)
    }

    func testWhenFetchedTopEntitiesThenShouldCallShowOnView() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        viewMock.verifyCalled(.showItems)
    }

    func testViewModelsContentFormatting() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        let expectedViewModels = topEntries.map({ makeViewModel(for: $0) })
        viewMock.verifyContains(expectedViewModels)
    }

    func testWhenFailedToFetchTopEntriesThenShouldShowErrorMessage() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        presenter.viewLoaded()
        presenter.failedToFetchTopEntries(with: error)
        viewMock.verifyCalled(.showAlertWithMessage)
    }

    func testErrorFormatting() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        presenter.viewLoaded()
        presenter.failedToFetchTopEntries(with: error)
        viewMock.verifyMessageFormat(error.localizedDescription)
    }

    func testWhenIsDisplayingAntepenultimateItemThenFetchMore() {
        let (presenter, interactorMock) = makeInstanceWithInteractorMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        interactorMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        interactorMock.verifyCalled(.fetchMore)
    }

    func testWhenIsDisplayingNotAnAntepenultimateItemThenDoNotFetchMore() {
        let (presenter, interactorMock) = makeInstanceWithInteractorMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        interactorMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub0))
        presenter.willDisplayItem(makeViewModel(for: .stub2))
        presenter.willDisplayItem(makeViewModel(for: .stub3))
        interactorMock.verifyWasNotCalled()
    }

    func testWhenFetchedMoreThenShouldCallShowOnView() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        viewMock.clear()
        moveToSuccessfullyFetchedMoreState(presenter, antepenultimateItem: .stub1, with: topEntries)
        viewMock.verifyCalled(.showItems)
        let totalList = topEntries + topEntries
        viewMock.verifyContains(totalList.map({ makeViewModel(for: $0) }))
    }

    func testWhenFailedToFetchMoreThenShouldCallShowErrorMessage() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        viewMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        presenter.failedToFetchTopEntries(with: error)
        viewMock.verifyCalled(.showAlertWithMessage)
        viewMock.verifyMessageFormat(error.localizedDescription)
    }

    func testRefreshShouldCallFetchOnInteractor() {
        let (presenter, interactorMock) = makeInstanceWithInteractorMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        interactorMock.clear()
        presenter.refresh()
        interactorMock.verifyCalled(.fetch)
    }

    func testWhenRefreshedThenShouldCallShowOnViewWithOnlyNewEntries() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        viewMock.clear()
        moveToSuccessfullyRefreshedState(presenter, with: [.stub0])
        viewMock.verifyContains([makeViewModel(for: .stub0)])
    }

    func testGivenFinishedRefreshWhenCalledFetchMoreThenShouldCallFetchMoreOnInteractor() {
        let (presenter, interactorMock) = makeInstanceWithInteractorMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        moveToSuccessfullyRefreshedState(presenter, with: topEntries)
        interactorMock.clear()
        presenter.willDisplayItem(makeViewModel(for: .stub1))
        interactorMock.verifyCalled(.fetchMore)
    }

    func testWhenFetchedMoreAfterRefreshThenShouldCallShowOnViewWithConcatenatedItems() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        moveToSuccessfullyRefreshedState(presenter, with: topEntries)
        viewMock.clear()
        moveToSuccessfullyFetchedMoreState(presenter, antepenultimateItem: .stub1, with: topEntries)
        let allEntries = topEntries + topEntries
        viewMock.verifyContains(allEntries.map({ makeViewModel(for: $0) }))
    }

    func testGivenFailedRefreshWhenFetchedMoreThenShouldCallShowOnViewWithConcatenatedItems() {
        let (presenter, viewMock) = makeInstanceWithViewMock()
        moveToInitiallyLoadedState(presenter, with: topEntries)
        moveToFailedRefreshedState(presenter, with: error)
        viewMock.clear()
        moveToSuccessfullyFetchedMoreState(presenter, antepenultimateItem: .stub1, with: topEntries)
        let allEntries = topEntries + topEntries
        viewMock.verifyContains(allEntries.map({ makeViewModel(for: $0) }))
    }

}

private extension TopListPresenterTests {

    func makeInstance(interactor: FetchTopEntriesInteractorInput = FetchTopEntriesInteractorDummy(),
                      imageRepository: ImageRepository = ImageRepositoryDummy(),
                      view: TopEntryListView = TopEntryListViewDummy()) -> TopEntryListPresenterImpl {
        let presenter = TopEntryListPresenterImpl(interactor, imageRepository)
        presenter.view = view
        return presenter
    }

    func makeInstanceWithViewMock() -> (TopEntryListPresenterImpl, TopEntryListViewMock) {
        let viewMock = TopEntryListViewMock()
        return (makeInstance(view: viewMock), viewMock)
    }

    func makeInstanceWithInteractorMock() -> (TopEntryListPresenterImpl, FetchTopEntriesInteractorMock) {
        let interactorMock = FetchTopEntriesInteractorMock()
        return (makeInstance(interactor: interactorMock), interactorMock)
    }

}

private extension TopListPresenterTests {

    func moveToInitiallyLoadedState(_ presenter: TopEntryListPresenterImpl, with entries: [TopEntry]) {
        presenter.viewLoaded()
        presenter.didFetchTopEntries(entries)
    }

    func moveToSuccessfullyRefreshedState(_ presenter: TopEntryListPresenterImpl,
                                          with newEntries: [TopEntry]) {
        presenter.refresh()
        presenter.didFetchTopEntries(newEntries)
    }

    func moveToFailedRefreshedState(_ presenter: TopEntryListPresenterImpl,
                                    with error: Error) {
        presenter.refresh()
        presenter.failedToFetchTopEntries(with: error)
    }

    func moveToSuccessfullyFetchedMoreState(_ presenter: TopEntryListPresenterImpl,
                                            antepenultimateItem: TopEntry,
                                            with newEntries: [TopEntry]) {
        presenter.willDisplayItem(makeViewModel(for: antepenultimateItem))
        presenter.didFetchTopEntries(newEntries)
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
