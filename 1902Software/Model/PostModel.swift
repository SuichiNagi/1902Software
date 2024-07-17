//
//  PostModel.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import Foundation

struct PostModel: Codable {
    let id: String
    let userId: String
    var title: String?
    var body: String?
    let image: String
}
