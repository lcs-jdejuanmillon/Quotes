//
//  Quote.swift
//  Quotes
//
//  Created by Jacobo de Juan Millon on 2022-02-22.
//

import Foundation

struct Quote: Decodable, Hashable, Encodable {
    let quoteText: String
    let quoteAuthor: String
}
