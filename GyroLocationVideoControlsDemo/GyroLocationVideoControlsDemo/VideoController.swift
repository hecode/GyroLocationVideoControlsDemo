//
//  VideoController.swift
//  GyroLocationVideoControlsDemo
//
//  Created by ibrahim beltagy on 11/06/2022.
//

import UIKit
import AVKit
import AVFoundation
import CoreLocation
import CoreMotion

class VideoController: UIViewController {
    let locationManager = CLLocationManager()
    var startingLocation: CLLocation?
    var avVC: AVPlayerViewController?
    var motion = CMMotionManager()
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupLocation()
        setupGyro()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        launchVideo()
    }
    
    // MARK: - Actions
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            pauseVideo()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else {
            return
        }
        
        if let newValue = change[.newKey] as? CGRect {
            if newValue.minY > 100 {
                self.avVC?.removeObserver(self, forKeyPath: #keyPath(UIViewController.view.frame))
                self.avVC?.player = nil
                self.avVC = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}

// MARK: - Video Handling

extension VideoController {
    
    func launchVideo() {
        avVC = AVPlayerViewController()
        
        guard let url = viewModel.getVideoURL() else {
            return
        }
        
        playVideo(url: url)
    }
    
    func playVideo(url: URL) {
        guard let avVC = avVC else { return }
        let player = AVPlayer(url: url)
        
        avVC.player = player
        self.present(avVC, animated: true) {
            self.avVC?.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.new], context: nil)
            self.avVC?.player?.play()
        }
    }
    
    func pauseVideo() {
        if avVC?.player?.timeControlStatus == .playing {
            avVC?.player?.pause()
        }
    }
    
    func resetVideo(playAfter: Bool = true) {
        pauseVideo()
        avVC?.player?.seek(to: .zero)
        if playAfter {
            avVC?.player?.play()
        }
    }
    
}


// MARK: - Location Handling

extension VideoController {
    
    func setupLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
}

// MARK: CLLocationManagerDelegate

extension VideoController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = manager.location else { return }
        
        if startingLocation == nil {
            startingLocation = currentLocation
        } else if let startingLocation = startingLocation, currentLocation.distance(from: startingLocation) >= 10 {
            resetVideo()
            self.startingLocation = currentLocation
        }
    }
    
}

// MARK: - Gyro Handling

extension VideoController {
    
    func setupGyro() {
        motion.gyroUpdateInterval = 1
        motion.startGyroUpdates(to: OperationQueue.current!) {
            (data, error) in
            if let trueData = data {
                let x = trueData.rotationRate.x
                let z = trueData.rotationRate.z
//                debugPrint(data as Any)

                if !(z < 0.5 && z > -0.5) {
                    if let currentTime = self.avVC?.player?.currentTime() {
                        let newTimeInSecs = currentTime.seconds.advanced(by: z <= 0 ? -1 : 1)
                        self.avVC?.player?.seek(to: CMTimeMakeWithSeconds(newTimeInSecs, preferredTimescale: currentTime.timescale))
                    }
                }
               
                if !(x < 0.5 && x > -0.5) {
                    if let volume = self.avVC?.player?.volume {
                        self.avVC?.player?.volume = volume + Float(x <= 0 ? -0.1 : 0.1)
                    }
                }
            }
        }
    }
    
}
