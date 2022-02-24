//
//  SharedFunctionsAndConstants.swift
//  Quotes
//
//  Created by Jacobo de Juan Millon on 2022-02-24.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

let savedFavouritesLabel =  "savedFavourites"

