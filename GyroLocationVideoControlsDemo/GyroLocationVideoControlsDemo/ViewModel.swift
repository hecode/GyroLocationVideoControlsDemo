//
//  ViewModel.swift
//  GyroLocationVideoControlsDemo
//
//  Created by ibrahim beltagy on 11/06/2022.
//

import Foundation

class ViewModel {
    
    private let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")
    
    func getVideoURL() -> URL? {
        return url
    }
    
}
