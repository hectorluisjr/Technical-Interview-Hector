//
//  Subtopic.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

public struct Subtopics: Codable{
    var subtopics: [Subtopic]
}

public struct Subtopic: Codable{
    
    var uuid: String
    var parentTopicUuid: String
    var title: String
    var position: Int
    var meditations: [String]
    
    private enum CodingKeys: String, CodingKey {
        case uuid, title, position, meditations
        case parentTopicUuid = "parent_topic_uuid"
    }
    
    func subtopicMeditations() -> [Meditation] {
        return (NetworkingManager.shared.meditations?.filter({meditations.contains($0.uuid)}) ?? [])
            .sorted(by: {($0.playCount ?? 0) < ($1.playCount ?? 0)})
    }
}

