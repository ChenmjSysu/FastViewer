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
    private(set) var fullPath: String
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        print("double click");
    }
    
    func isImageFile(url: NSURL) -> Bool {
        var type: String = getFileType(url: url);
        return UTTypeConformsTo(type as CFString, "public.image" as CFString)
    }
    
    func isFolder(url: NSURL) -> Bool {
        var type: String = getFileType(url: url);
        return UTTypeConformsTo(type as CFString, "public.folder" as CFString)
    }

    func getFileType(url: NSURL) -> String {
        var fileType: String = "Unknown";
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        do {
            let resourceValues = try url.resourceValues(forKeys: resourceValueKeys)
            guard let isRegularFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { return fileType }
//                guard isRegularFileResourceValue.boolValue else { continue }
            
            guard let fileType_ = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { return fileType }
            
            fileType = fileType_;
      
        }
        catch {
            print("Unexpected error occured: \(error).")
        }
        return fileType;
    }
    
    init() {
        fileName = "";
        fullPath = "";
        thumbnail = nil;
    }
    
    init (url: NSURL) {
        if let name = url.lastPathComponent {
            fileName = name
        } else {
            fileName = ""
        }
        fullPath = url.absoluteString!;
        if (isImageFile(url: url)) {
            let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as! CFURL, nil)
            if let imageSource = imageSource {
                guard CGImageSourceGetType(imageSource) != nil else { return }
                thumbnail = getThumbnailImage(imageSource: imageSource)
            }
        }
        else if (isFolder(url: url)) {
            thumbnail = NSImage(named: NSImage.Name("folder_icon"));
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
