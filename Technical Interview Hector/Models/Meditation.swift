//
//  Meditation.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

public struct Meditations: Codable{
    var meditations: [Meditation]
}

public struct Meditation: Codable{
    
    var uuid: String
    var title: String
    var teacherName: String
    var imageUrl: String
    var playCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case uuid, title
        case teacherName = "teacher_name"
        case imageUrl = "image_url"
        case playCount = "play_count"
    }
}
