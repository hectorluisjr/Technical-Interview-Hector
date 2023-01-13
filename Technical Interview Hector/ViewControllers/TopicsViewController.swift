//
//  TopicsViewController.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

class TopicsViewController: UIViewController {

    @IBOutlet weak var topicsCollectionView: UICollectionView!
    var topics: [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TopicsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicsCollectionViewCell", for: indexPath) as! TopicsCollectionViewCell
        let topic = topics[indexPath.row]
        cell.configureForTopic(topic: topic)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        let storyboard = UIStoryboard(name: "SubtopicsStoryboard", bundle: Bundle(for: Self.self))
        
        guard let subtopicsViewController = storyboard.instantiateInitialViewController() as? SubtopicsViewController else {return}
        subtopicsViewController.topic = topic
        navigationController?.pushViewController(subtopicsViewController, animated: true)
    }
}

