//
//  ViewController.swift
//  GyroLocationVideoControlsDemo
//
//  Created by ibrahim beltagy on 11/06/2022.
//

import UIKit

class ViewController: UIViewController {
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentVideoController()
    }

    
    // MARK: - Actions
    @IBAction func relaunchAction(_ sender: UIButton) {
        presentVideoController()
    }
    
    func presentVideoController() {
        let vc = VideoController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
