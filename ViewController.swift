//
//  ViewController.swift
//  DailyUseThingProject
//
//  Created by Manoj Kumar Gupta on 08/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Example of using APIManager to perform a request
        Task {
            do {
                let data = try await APIManager.shared.performRequest(endpoint: "your-endpoint")
                // Process the data
                print("Response data:", data)
            } catch {
                print("Error performing request:", error)
            }
        }
    }


}

