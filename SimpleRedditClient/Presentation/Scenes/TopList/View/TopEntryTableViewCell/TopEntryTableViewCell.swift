//
//  TopEntryTableViewCell.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import UIKit

class TopEntryTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorInfoLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var commentsCountLabel: UILabel!

    func configure(with viewModel: TopEntryViewModel) {
        titleLabel.text = viewModel.title
        authorInfoLabel.text = viewModel.info
        thumbnailImageView.isHidden = viewModel.thumbnail == nil
        if let imageData = viewModel.thumbnail {
            thumbnailImageView.image = UIImage(data: imageData)
        } else {
            thumbnailImageView.image = nil
        }
        commentsCountLabel.text = viewModel.commentsCount
    }

}
