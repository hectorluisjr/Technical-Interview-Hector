//
//  Topic.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

public struct Topics: Codable{
    var topics: [Topic]
}

public struct Topic: Codable{
    
    var uuid: String
    var title: String
    var position: Int
    var meditations: [String]
    var featured: Bool
    var color: String
    
    private enum CodingKeys: String, CodingKey {
        case uuid, title, position, meditations, featured, color
    }
    
    func subtopics() -> [Subtopic] {
        return (NetworkingManager.shared.subtopics?.filter({$0.parentTopicUuid == uuid}) ?? [])
            .sorted(by: {$0.position > $1.position})
    }
    
    func topicMeditations() -> [Meditation] {
        return (NetworkingManager.shared.meditations?.filter({meditations.contains($0.uuid)}) ?? [])
            .sorted(by: {($0.playCount ?? 0) < ($1.playCount ?? 0)})
    }
    
    func colorValue() -> UIColor {
        return hexStringToUIColor(hex: color)
    }
    
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

