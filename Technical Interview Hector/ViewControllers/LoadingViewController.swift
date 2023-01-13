//
//  LoadingViewController.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.startAnimating()
        
        NetworkingManager.shared.loadContentData {
            let storyboard = UIStoryboard(name: "TopicsStoryboard", bundle: Bundle(for: Self.self))
            
            guard let topicsViewController = storyboard.instantiateInitialViewController() as? TopicsViewController else {return}
            topicsViewController.topics = NetworkingManager.shared.topics ?? []
            self.navigationController?.pushViewController(topicsViewController, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
