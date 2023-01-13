//
//  SubtopicsCollectionViewMeditationCell.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

class SubtopicsCollectionViewMeditationCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    override func layoutSubviews() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        teacherLabel.text = nil
    }
    
    func configureForMeditation(meditation: Meditation){
        titleLabel.text = meditation.title
        teacherLabel.text = meditation.teacherName
        Task {
            do {
                let image = try await NetworkingManager.shared.loadImage(urlString: meditation.imageUrl)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
