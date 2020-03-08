//
//  ClickReleaseButton.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/8.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ClickReleaseButton: NSButton {
    
    override func mouseDown(with event: NSEvent) {
        let windowController = self.superview?.superview
//        let viewController = windowController.
        NSLog("Mouse Down");
    }
    
    override func mouseUp(with event: NSEvent) {
        NSLog("Mouse Up");
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
