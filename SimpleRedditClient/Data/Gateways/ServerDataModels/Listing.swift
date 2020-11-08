//
//  Listing.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

struct Listing<T: Decodable>: Decodable {

    let count: Int
    let children: [ListingElementWrapper<T>]
    let next: String?

    init(from decoder: Decoder) throws {
        let wrapper = try decoder.container(keyedBy: CodingKeys.self)
        let values = try wrapper.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .data)
        count = try values.decode(Int.self, forKey: .count)
        children = try values.decode([ListingElementWrapper].self, forKey: .children)
        next = try values.decode(String.self, forKey: .next)
    }

    enum CodingKeys: String, CodingKey {
        case data
    }
    enum EmbeddedKeys: String, CodingKey {
        case count = "dist"
        case children
        case next = "after"
    }

}

struct ListingElementWrapper<T: Decodable>: Decodable {

    let element: T

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        element = try values.decode(T.self, forKey: .element)
    }

    enum CodingKeys: String, CodingKey {
        case element = "data"
    }

}
