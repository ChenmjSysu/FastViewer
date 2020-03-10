//
//  WindowController.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/10.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    @IBAction func OpenFolder(_ sender: Any) {
        OpenAnotherFolder();
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func OpenAnotherFolder() {
        let openPanel = NSOpenPanel();
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles       = false;
        openPanel.showsHiddenFiles     = false;

        openPanel.beginSheetModal(for: self.window!) { (response) -> Void in
            guard response.rawValue == NSFileHandlingPanelOKButton else {return}
            let viewController = self.contentViewController as? ViewController
            if let viewController = viewController, let URL = openPanel.url {
                viewController.loadDataForNewFolderWithUrl(folderURL: URL as NSURL)
            }
        }       
   }

}
