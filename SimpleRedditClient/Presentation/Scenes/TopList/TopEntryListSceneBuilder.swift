//
//  TopEntryListSceneBuilder.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import UIKit

final class TopEntryListSceneBuilder {

    func build() -> TopEntryListViewController {
        let viewController: TopEntryListViewController = UIStoryboard(.main).instantiateViewController()
        let restClient = RestClientImpl()
        let gateway = TopEntryGatewayImpl(restClient)
        let imageGateway = ImageGatewayImpl(restClient)
        let imageRepository = ImageRepositoryImpl(imageGateway)
        let interactor = FetchTopEntriesInteractor(gateway)
        let presenter = TopEntryListPresenterImpl(interactor, imageRepository)
        interactor.output = presenter
        viewController.presenter = presenter
        presenter.view = viewController
        return viewController
    }

}
