//
//  TopicsCollectionViewCell.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

class TopicsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func layoutSubviews() {
        containerView.layer.masksToBounds = true
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        colorView.backgroundColor = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
    
    func configureForTopic(topic: Topic){
        colorView.backgroundColor = topic.colorValue()
        titleLabel.text = topic.title
        
        let subtopicMeditationCount = topic.subtopics().reduce(0) {$0 + $1.meditations.count}
        let totalMeditationCount = subtopicMeditationCount + topic.meditations.count
        countLabel.text = "\(totalMeditationCount) meditations"
    }
    
}
