//
//  ViewController.swift
//  iOS-BLE
//
//  Created by CHI on 26/11/2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let peripheralsList = PeripheralsList()
        let hostView = UIHostingController(rootView: peripheralsList)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostView.view)
        
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            hostView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostView.view.heightAnchor.constraint(equalTo: view.heightAnchor),
        ]

        self.view.addConstraints(constraints)
    }


}

