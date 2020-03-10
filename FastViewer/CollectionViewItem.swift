//
//  CollectionViewItem.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/10.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    // 1 define imageFile property
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil;
                textField?.stringValue = "";
            }
        }
    }
    
    // 2 change background of item's view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true;
        view.layer?.backgroundColor = NSColor.white.cgColor;
        
        // 1
        view.layer?.borderWidth = 0.0
        // 2
        view.layer?.borderColor = NSColor.blue.cgColor;
    }
    
    func setHighlight(selected: Bool) {
        view.layer?.borderWidth = selected ? 1.0 : 0.0
    }
    
}
