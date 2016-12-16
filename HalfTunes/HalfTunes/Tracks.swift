//
//  Tracks.swift
//  HalfTunes
//
//  Created by Arpit Pittie on 15/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

class Tracks {
    var name: String?
    var artist: String?
    var previewUrl: String?
    
    init(name: String?, artist: String?, previewUrl: String?) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
    }
}
