//
//  SubtopicsViewController.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

class SubtopicsViewController: UIViewController {

    @IBOutlet weak var subtopicsCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    var topic: Topic?
    var subtopics: [Subtopic]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = topic?.title ?? ""
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension SubtopicsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < topic?.subtopics().count ?? 0 {
            return topic?.subtopics()[section].subtopicMeditations().count ?? 0
        } else {
            return topic?.topicMeditations().count ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let topicMeditationCount = topic?.topicMeditations().count ?? 0
        let topicSubtopicsCount = topic?.subtopics().count ?? 0
        let topicHasMeditations =  topicMeditationCount > 0
        
        if topicHasMeditations {
            return topicSubtopicsCount + 1
        }
        
        return topicSubtopicsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubtopicsCollectionViewMeditationCell", for: indexPath) as! SubtopicsCollectionViewMeditationCell
        let meditation: Meditation?
        if indexPath.section < topic?.subtopics().count ?? 0 {
            meditation = topic?.subtopics()[indexPath.section].subtopicMeditations()[indexPath.row]
        } else {
            meditation = topic?.topicMeditations()[indexPath.row]
        }
        
        if let meditation = meditation {
            cell.configureForMeditation(meditation: meditation)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubtopicsCollectionHeaderReusableView", for: indexPath) as! SubtopicsCollectionHeaderReusableView
        
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionTitle: String?
            if indexPath.section < topic?.subtopics().count ?? 0 {
                sectionTitle = topic?.subtopics()[indexPath.section].title
            } else {
                sectionTitle = "Meditations"
            }
            headerView.titleLabel.text = sectionTitle
        }
        
        return headerView
    }
}
