//
//  ImageWindowController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/28.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ImageWindowController: NSWindowController {

    @IBAction func ZoomClick(_ sender: Any) {
        guard let segmentedControl  = sender as? NSSegmentedControl else {
            return;
        }
        let viewController = self.contentViewController as! ImageViewController;
        switch segmentedControl.selectedSegment {
        case 0: viewController.zoomIn(sender: nil);
        case 1: viewController.zoomOut(sender: nil);
        case 2: viewController.zoomToActual(sender: nil);
        case 3: viewController.zoomToFit(sender: nil);
        default:
            return;
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
