//
//  ImageFile.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/9.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ImageFile {

    private(set) var thumbnail: NSImage?
    private(set) var fileName: String
    
    init (url: NSURL) {
        if let name = url.lastPathComponent {
            fileName = name
        } else {
            fileName = ""
        }
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as! CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else { return }
            thumbnail = getThumbnailImage(imageSource: imageSource)
        }
    }
    
    private func getThumbnailImage(imageSource: CGImageSource) -> NSImage? {
        let thumbnailOptions = [
            String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
            String(kCGImageSourceThumbnailMaxPixelSize): 160
        ] as [String: Any]
        guard let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary) else { return nil }
        return NSImage(cgImage: thumbnailRef, size: NSSize.zero)
    }
    
}
