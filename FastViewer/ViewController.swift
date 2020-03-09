//
//  ViewController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/27.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let imageDirectoryLoader = ImageDirectoryLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let initialFolderUrl = NSURL.fileURL(withPath: "/Users/chenmingjin/Desktop", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl as NSURL)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        if segue.destinationController is ImageWindowController
        {
            let vc = segue.destinationController as? ImageWindowController
        
            NSLog("Open One Image");
        }
        else if segue.destinationController is TwoImagesWindowController
        {
            let windowController = segue.destinationController as? TwoImagesWindowController
            let viewController = windowController?.contentViewController as! TwoImagesViewController;
            viewController.imageFilePath0 = "/Users/chenmingjin/workplace/code/WechatIMG7.jpeg"
            viewController.imageFilePath1 = "/Users/chenmingjin/workplace/code/WechatIMG9.jpeg"
            // 更新显示的图像
            viewController.updateImage();
            NSLog("Open TwoImage");
        }
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL)
    }

}

