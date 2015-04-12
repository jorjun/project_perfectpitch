//
//  recorded_audio.swift
//  Pitch Perfect
//
//  Created by jorjun on 31/03/2015.
//  Copyright (c) 2015 jorjun technical services. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var title: String!
    var file_path_url: NSURL!
    
    init(title:String, file_path_url:NSURL) {
        self.title = title
        self.file_path_url = file_path_url
    }
}