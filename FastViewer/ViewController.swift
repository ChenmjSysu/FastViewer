//
//  ViewController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/27.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var imageFilePath0 = "";
    var imageFilePath1 = "";
    
    var twoImageWindowController: TwoImagesWindowController?
    var imageWindowController: ImageWindowController?
    
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    let imageDirectoryLoader = ImageDirectoryLoader()
    var lastClickTime:  CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
    
    @IBAction func EnterPathTextField(_ sender: Any) {
        let path = pathTextField.stringValue;
        let helper: ImageFile = ImageFile();
        if (helper.isFolder(url: NSURL.init(string: "file://" + path)!)) {
            loadDataForNewFolderWithUrl(folderURL: NSURL.init(string: "file://" + path)!);
//            let initialFolderUrl = NSURL.fileURL(withPath: path, isDirectory: true);
//            imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl as NSURL);
        }
        else {
            print(path, " is not a valid folder");
        }
    }
    override func mouseDown(with event: NSEvent) {
        print("click view")
    }

    private func configureCollectionView() {
        // 1 create layout
        let flowLayout = NSCollectionViewFlowLayout();
        // 设置iterm样式
        flowLayout.itemSize = NSSize(width: 80.0, height: 70.0);
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0);
        flowLayout.minimumInteritemSpacing = 20.0;
        flowLayout.minimumLineSpacing = 20.0;
        collectionView.collectionViewLayout = flowLayout;
        // 2 For optimal performance, NSCollectionView is designed to be layer-backed
        view.wantsLayer = true;
        // 3 set background color
        collectionView.layer?.backgroundColor = NSColor.black.cgColor;
    }
    
    func openImageWindow() {
        let index:IndexSet = collectionView.selectionIndexes;
        print("select count ", index.count);
        
        if (index.count == 0) {
            print("No selection")
        }
        else if (index.count == 1) {
            let storyboard = NSStoryboard.init(name: "Main", bundle: nil);
            imageWindowController = storyboard.instantiateController(withIdentifier: "SingleImageWindow") as! ImageWindowController;
            let vc = imageWindowController?.contentViewController as! ImageViewController;
            vc.imageFilePath0 = imageFilePath0;
            vc.updateImage();
            vc.zoomToFit(sender: nil);
            imageWindowController?.showWindow(self);
        }
        else if (index.count == 2) {
            let storyboard = NSStoryboard.init(name: "Main", bundle: nil);
            twoImageWindowController = storyboard.instantiateController(withIdentifier: "TwoImageWindow") as! TwoImagesWindowController;
            let vc = twoImageWindowController?.contentViewController as! TwoImagesViewController;
            vc.imageFilePath0 = imageFilePath0;
            vc.imageFilePath1 = imageFilePath1;
            vc.updateImage();
            vc.zoomToFit(sender: nil);
            imageWindowController?.showWindow(self);
        }
        else {
            print("Unsupport image count > 2");
        }
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

    // 只有在点击下方的按钮才会调用到这里，如果是点击toolbar的按钮，不会调用这里
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        if segue.destinationController is ImageWindowController
        {
            let windowController = segue.destinationController as? ImageWindowController
            let vc = segue.destinationController as? ImageWindowController
            
            let viewController = windowController?.contentViewController as! ImageViewController;
            viewController.imageFilePath0 = imageFilePath0;
            // 更新显示的图像
            viewController.updateImage();
            viewController.zoomToFit(sender: nil);
            NSLog("Open One Image");
        }
        else if segue.destinationController is TwoImagesWindowController
        {
            let windowController = segue.destinationController as? TwoImagesWindowController
            let viewController = windowController?.contentViewController as! TwoImagesViewController;
            viewController.imageFilePath0 = imageFilePath0;
            viewController.imageFilePath1 = imageFilePath1;
            // 更新显示的图像
            viewController.updateImage();
            viewController.zoomToFit(sender: nil);
            NSLog("Open TwoImage");
        }
    }
    
    // 打开新的文件夹
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
        // reload files
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL);
        // redisplay files
        collectionView.reloadData();
        // set path editfile;
        let urlString: String = folderURL.relativePath!
        pathTextField.stringValue = urlString;
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
        
        if let selectedIndexPath = collectionView.selectionIndexPaths.first, selectedIndexPath == indexPath as IndexPath {
            collectionViewItem.setHighlight(selected: true)
        } else {
            collectionViewItem.setHighlight(selected: false)
        }
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
    
    if let selectedIndexPath = collectionView.selectionIndexPaths.first, selectedIndexPath == indexPath as IndexPath {
        collectionViewItem.setHighlight(selected: true)
    } else {
        collectionViewItem.setHighlight(selected: false)
    }
    return item
  }
}

extension ViewController : NSCollectionViewDelegate {
    
    // 1 when click item, the function is called
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        let index:IndexSet = collectionView.selectionIndexes;
      
        var selectIndex:Int = 0;
        for i in index {
            guard let oneItem = collectionView.item(at: i) else {
                return
            }
            if (selectIndex == 0) {
                imageFilePath0 = (oneItem as! CollectionViewItem).imageFile!.fullPath;
            }
            else if (selectIndex == 1) {
                imageFilePath1 = (oneItem as! CollectionViewItem).imageFile!.fullPath;
            }
            selectIndex += 1;
        }
        
        print(imageFilePath0)
        print(imageFilePath1)
        
        var currentClickTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent();
        let diffTime = currentClickTime - lastClickTime;
        print(diffTime);
        if (diffTime < 1) {
            print("Double Click");
        }
        
        lastClickTime = CFAbsoluteTimeGetCurrent();
        // 2 get the selected item
        guard let indexPath = indexPaths.first else {
            return
        }
        // 3 retrive an item by its index and highlight it
        guard let item = collectionView.item(at: indexPath as IndexPath) else {
            return
        }
        (item as! CollectionViewItem).setHighlight(selected: true)
//        print((item as! CollectionViewItem).imageFile?.fullPath);
    }

    // 4 same as previous method, but it's called when is deselected
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
        let selectedIndex:IndexSet = collectionView.selectionIndexes;
        
        let index = collectionView.indexPathsForVisibleItems();
        for i in index {
            
            if (selectedIndex.contains(i.item)) {
                continue;
            }
            print("DeSelect ", i.item);
            guard let item = collectionView.item(at: i) else {
                return
            }
            (item as! CollectionViewItem).setHighlight(selected: false)
        }
//        guard let indexPath = indexPaths.first else {
//            return
//        }
            
    }
    
//    func collectionView(_ collectionView: NSCollectionView, didDoubleClickItemsAt indexPaths: Set<IndexPath>) {
//        print("clclc");
//    }
    
}

//protocol NSCollectionViewClickHandler {
//    func collectionView(_ collectionView: NSCollectionView, didDoubleClickOnItem item: Int)
//    func collectionView(_ collectionView: NSCollectionView, didRightClickOnItem item: Int)
//}
//
//extension ViewController: NSCollectionViewClickHandler {
//   func collectionView(_ collectionView: NSCollectionView, didDoubleClickOnItem item: Int) {
//      print("didDoubleClickOnItem")
//   }
//
//   func collectionView(_ collectionView: NSCollectionView, didRightClickOnItem item: Int) {
//      print("didDoubleClickOnItem")
//   }

   // If you need other methods to properly implement your delegate methods,
   // you can group them in this extension as well: they logically belong together.
   // …
//}

