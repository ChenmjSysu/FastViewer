//
//  ImageFile.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/9.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

func getFileDescription(filepath: String) -> String {
    
    var desc: String = "";
    let filename = NSURL(fileURLWithPath: filepath).lastPathComponent;
    desc = filename! + "\n";
    
    let tmp = ImageFile();
    let formatString = "file://" + filepath;
    let encodeString = formatString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed);
    let url = NSURL.init(string: encodeString!)!
    if (tmp.isImageFile(url: url)) {
        let image = NSImage.init(contentsOf: url as URL);
        let width = Int((image?.size.width)!)
        let height = Int((image?.size.height)!)
        desc += "宽: " + String(width) + " 高:" + String(height) + "\n";
    }
    
    do {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filepath)
        if let fileSize:NSNumber = fileAttributes[FileAttributeKey.size] as! NSNumber? {
            print("File Size: \(fileSize.uint32Value)")
            desc += "大小: " + String(fileSize.uint32Value) + " B";
        }
        
        if let ownerName = fileAttributes[FileAttributeKey.ownerAccountName] {
            print("File Owner: \(ownerName)")
            desc += "\n所有者: " + String(ownerName as! String);
        }
     
        if let creationDate = fileAttributes[FileAttributeKey.creationDate] {
            print("File Creation Date: \(creationDate)")
            desc += "\n" + String("创建时间: \(creationDate)")
        }
        
        if let modificationDate = fileAttributes[FileAttributeKey.modificationDate] {
            print("File Modification Date: \(modificationDate)")
            desc += "\n" + String("修改时间: \(modificationDate)")
        }
        
    } catch let error as NSError {
        print("Get attributes errer: \(error)")
    }
    return desc;
}

class ImageFile {

    private(set) var thumbnail: NSImage?
    private(set) var fileName: String
    private(set) var fullPath: String
    private(set) var description: String
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        print("ImageFile double click");
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
        description = "";
        thumbnail = nil;
    }
    

    
    init (url: NSURL) {
        if let name = url.lastPathComponent {
            fileName = name
        } else {
            fileName = ""
        }
        fullPath = url.absoluteString!;
        description = getFileDescription(filepath: url.path!);
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
