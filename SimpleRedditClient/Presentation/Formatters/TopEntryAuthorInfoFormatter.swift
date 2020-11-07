//
//  TopEntryAuthorInfoFormatter.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

final class TopEntryAuthorInfoFormatter {

    func infoString(for topEntry: TopEntry) -> String {
        let relativeDateFormatter = RelativeDateTimeFormatter()
        let timeAgoString = relativeDateFormatter.localizedString(for: topEntry.entryDate,
                                                                  relativeTo: Date())
        return "\(topEntry.author) - \(timeAgoString)"
    }
}
