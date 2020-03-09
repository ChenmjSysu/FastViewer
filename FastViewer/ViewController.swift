//
//  ViewController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/27.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    let imageDirectoryLoader = ImageDirectoryLoader()
    
    private func configureCollectionView() {
        // 1 create layout
        let flowLayout = NSCollectionViewFlowLayout();
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0);
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0);
        flowLayout.minimumInteritemSpacing = 20.0;
        flowLayout.minimumLineSpacing = 20.0;
        collectionView.collectionViewLayout = flowLayout;
        // 2 For optimal performance, NSCollectionView is designed to be layer-backed
        view.wantsLayer = true;
        // 3 set background color
        collectionView.layer?.backgroundColor = NSColor.black.cgColor;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let initialFolderUrl = NSURL.fileURL(withPath: "/Users/chenmingjin/Downloads", isDirectory: true);
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl as NSURL);
        configureCollectionView();
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
        // reload files
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL);
        // redisplay files
        collectionView.reloadData();
    }
}

extension ViewController : NSCollectionViewDataSource {
    // 3 返回某个index的item
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath as IndexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        // 5
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath as NSIndexPath)
        collectionViewItem.imageFile = imageFile
        return item
    }
    
  
  // 1 返回section个数
  func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
    return imageDirectoryLoader.numberOfSections
  }
  
  // 2 返回特定section的item个数
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageDirectoryLoader.numberOfItemsInSection(section: section)
  }
  
  // 3 返回某个index的item
  func collectionView(_collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
    
    // 4
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath as IndexPath)
    guard let collectionViewItem = item as? CollectionViewItem else {return item}
    
    // 5
    let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath)
    collectionViewItem.imageFile = imageFile
    return item
  }
  
}


