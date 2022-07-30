//
//  Picture.swift
//  StormViewer
//
//  Created by Huy Bui on 2022-07-30.
//

import Foundation

struct Picture: Codable {
    private(set) var fileName: String
    var viewCount: Int
    
    init(fileName: String, viewCount: Int) {
        self.fileName = fileName
        self.viewCount = viewCount
    }
}
