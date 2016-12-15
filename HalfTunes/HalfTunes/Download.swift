//
//  Download.swift
//  HalfTunes
//
//  Created by Arpit Pittie on 15/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: String) {
        self.url = url
    }
}
