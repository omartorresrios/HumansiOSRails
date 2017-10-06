//
//  FeedViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 5/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func goToStartView(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "StartView")
        self.present(controller!, animated: true, completion: nil)
        
    }

}
