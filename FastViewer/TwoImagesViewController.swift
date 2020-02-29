//
//  TwoImagesViewController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/28.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class TwoImagesViewController: NSViewController {

    @IBOutlet weak var scrollView0: NSScrollView!
    @IBOutlet weak var clipView0: CenteringClipView!
    @IBOutlet weak var viewHeightConstraint0: NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint0: NSLayoutConstraint!
    @IBOutlet weak var image0: NSImageView!
    
    @IBOutlet weak var scrollView1: NSScrollView!
    @IBOutlet weak var clipView1: CenteringClipView!
    @IBOutlet weak var viewHeightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint1: NSLayoutConstraint!
    @IBOutlet weak var image1: NSImageView!
    
    // 缩放的速度
    var zoomSpeed: CGFloat = 0.05;
    
    var MoveSpeed: CGFloat = 10;
    
    // 定义zoomFactor变量，表示图片的缩放比例
    var zoomFactor0:CGFloat = 1.0 {
        // 当变量发生变化是，执行didSet
        didSet {
            // 如果图像为空，马上返回
            guard image0.image != nil else {
                return
            }
            
            // 根据zoomFactor改变图像clip view的尺寸
            // Setting the the constraint constants for the height and the width will automatically invalidate the layout for the view and force a re-draw
            viewHeightConstraint0.constant = image0.image!.size.height * zoomFactor0;
            viewWidthConstraint0.constant = image0.image!.size.width * zoomFactor0;
            NSLog("缩放比例0: %f", zoomFactor0);
        }
    }
    var zoomFactor1:CGFloat = 1.0 {
        // 当变量发生变化是，执行didSet
        didSet {
            // 如果图像为空，马上返回
            guard image1.image != nil else {
                return
            }
            
            // 根据zoomFactor改变图像clip view的尺寸
            // Setting the the constraint constants for the height and the width will automatically invalidate the layout for the view and force a re-draw
            viewHeightConstraint1.constant = image1.image!.size.height * zoomFactor1;
            viewWidthConstraint1.constant = image1.image!.size.width * zoomFactor1;
            NSLog("缩放比例1: %f", zoomFactor0);
        }
    }
    
    func getZoomIn(index: Int) -> CGFloat {
        var factorIn: CGFloat;
        switch index {
        case 0:
            factorIn = zoomFactor0;
        case 1:
            factorIn = zoomFactor1;
        default:
            return 1;
        }
        
        if factorIn + zoomSpeed > 4 {
            factorIn = 4;
        } else if factorIn == 0.05 {
            factorIn = zoomSpeed;
        } else {
            factorIn += zoomSpeed;
        }
        return factorIn;
    }
    
    func getZoomOut(index: Int) -> CGFloat {
        var factorIn: CGFloat;
        switch index {
        case 0:
            factorIn = zoomFactor0;
        case 1:
            factorIn = zoomFactor1;
        default:
            return 1;
        }

        if factorIn - zoomSpeed < 0.05 {
            factorIn = 0.05;
        } else {
            factorIn -= zoomSpeed;
        }
        return factorIn;
    }
    
    func getZoomFit(index: Int) -> CGFloat {
        var factorOut: CGFloat;
        var image: NSImageView;
        var clipView: CenteringClipView;
        
        switch index {
        case 0:
            image = image0;
            clipView = clipView0;
        case 1:
            image = image1;
            clipView = clipView1;
        default:
            return 1;
        }
        
        guard image.image != nil else {
            return 1;
        }
        let imSize = image.image!.size;
        var clipSize = clipView.bounds.size;
        guard imSize.width > 0 && imSize.height > 0 && clipSize.width > 0 && clipSize.height > 0 else {
            return 1;
        }
        
        /*
         We want a 20 pixel gutter(margin). To make the calculations easier, adjust the clipbounds down to account for the gutter.
         Use 2 * the pixel gutter, since we are adjust only the height and width (this accounts for the left and right margin combined,
         and the top and bottom margin combined. )
        */
        let imageMargin:CGFloat = 40;
        
        clipSize.width -= imageMargin;
        clipSize.height -= imageMargin;
        
        let clipAspectRatio = clipSize.width / clipSize.height;
        let imAspectRatio = imSize.width / imSize.height;
        
        if (clipAspectRatio > imAspectRatio) {
            factorOut = clipSize.height / imSize.height;
        } else {
            factorOut = clipSize.width / imSize.width;
        }
        
        return factorOut;
    }
    
    @IBAction func zoomIn(sender: NSToolbarItem?) {
        NSLog("zoomIn");
        zoomFactor0 = getZoomIn(index: 0);
        zoomFactor1 = getZoomIn(index: 1);
    }
    
    @IBAction func zoomOut(sender: NSToolbarItem?) {
        zoomFactor0 = getZoomOut(index: 0);
        zoomFactor1 = getZoomOut(index: 1);
    }
    
    @IBAction func zoomToActual(sender: NSToolbarItem?) {
        zoomFactor0 = 1.0;
        zoomFactor1 = 1.0;
    }
    
    @IBAction func zoomToFit(sender: NSToolbarItem?) {
        zoomFactor0 = getZoomFit(index: 0);
        zoomFactor1 = getZoomFit(index: 1);
    }
    
    func doMoveLeft(scrollView: inout NSScrollView) {
        let rect = scrollView.contentView.documentVisibleRect;
        // 移动到指定点
        scrollView.contentView.scroll(CGPoint(x: rect.origin.x-MoveSpeed, y: rect.origin.y));
    }
    
    func doMoveRight(scrollView: inout NSScrollView) {
        let rect = scrollView.contentView.documentVisibleRect;
        // 移动到指定点
        scrollView.contentView.scroll(CGPoint(x: rect.origin.x+MoveSpeed, y: rect.origin.y));
    }
    
    func doMoveUp(scrollView: inout NSScrollView) {
        let rect = scrollView.contentView.documentVisibleRect;
        // 移动到指定点
        NSLog("%f ", rect.origin.y)
//        scrollView.contentView.scroll(CGPoint(x: rect.origin.x, y: rect.origin.y-MoveSpeed));
        scrollView.contentView.scroll(CGPoint(x: rect.origin.x, y: 100));
    }
    
    func doMoveDown(scrollView: inout NSScrollView) {
        let rect = scrollView.contentView.documentVisibleRect;
        // 移动到指定点
        NSLog("%f ", rect.origin.y)
//        scrollView.contentView.scroll(CGPoint(x: rect.origin.x, y: rect.origin.y+MoveSpeed));
    }
    
    @IBAction func moveLeft(sender: NSToolbarItem?) {
        NSLog("Move Left");
        
        doMoveLeft(scrollView: &scrollView0);
        doMoveLeft(scrollView: &scrollView1);
    }
    
    @IBAction func moveRight(sender: NSToolbarItem?) {
        NSLog("Move Right");
        
        doMoveRight(scrollView: &scrollView0);
        doMoveRight(scrollView: &scrollView1);
    }
    
    @IBAction func moveUp(sender: NSToolbarItem?) {
        NSLog("Move Up");
        
        doMoveUp(scrollView: &scrollView0);
        doMoveUp(scrollView: &scrollView1);
    }
    
    @IBAction func moveDown(sender: NSToolbarItem?) {
        NSLog("Move Down");
        
        doMoveDown(scrollView: &scrollView0);
        doMoveDown(scrollView: &scrollView1);
    }
    
    
    


    @objc func scrollViewDidLiveScroll(notification: Notification){
        #if DEBUG
        let rect = scrollView0.contentView.documentVisibleRect;
        NSLog("\nRect Scroll To %0.2f %0.2f", rect.origin.x, rect.origin.y);
        
        let rectB = scrollView0.contentView.bounds;
        NSLog("\nBound Scroll To %0.2f %0.2f", rectB.origin.x, rectB.origin.y);
        #endif
    }
    
    // 监听事件
    func addScrollListener(scrollView: inout NSScrollView) {
        let nc =  NotificationCenter.default
        
        nc.addObserver(
            self,
            selector: #selector(scrollViewDidLiveScroll),
            name: NSScrollView.didLiveScrollNotification,
            object: scrollView
        )
    }
    
    func initScroller() {
       
//        self.scrollView0.hasVerticalScroller = false;
//        self.scrollView0.hasHorizontalRuler = false;
//
//        self.scrollView1.hasVerticalScroller = false;
//        self.scrollView1.hasHorizontalRuler = false;
        
        addScrollListener(scrollView: &self.scrollView0);
//        addScrollListener(scrollView: &self.scrollView1);

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        zoomToActual(sender: nil);
        
        initScroller();
        
//        scrollView0.contentView.scroll(CGPoint(x: 200, y: 1000));
//        scrollView0.documentView?.scroll(.zero);
        if (scrollView0.hasVerticalScroller) {
            scrollView0.verticalScroller?.floatValue = 0;
            NSLog("hhh %d", 11);
        }
        let height = CGFloat((scrollView0.documentView?.frame.size.height)!);
//        scrollView0.documentView.scroll(NSPoint(x: 0, y: 1000))
//        scrollView0.documentView?.scroll(NSPoint(x: 1000, y: 0))
//        scrollView0.contentView.scroll(to: NSPoint(x: 0, y: -100));
        
//        scrollView0.contentView.setBoundsOrigin(NSPoint(x: 50, y: -100));
//        scrollView0.reflectScrolledClipView(scrollView0.contentView);
        let size = scrollView0.documentView?.frame.size;
        var visi: CGRect = scrollView0.documentVisibleRect;
        let bound = scrollView0.documentView?.bounds;
        let contentB = scrollView0.contentView.bounds;
        let contentS = scrollView0.contentSize;
        visi.origin = NSPoint(x: 0, y: 1000);
        scrollView0.documentView?.scrollToVisible(visi)
        let a = 1;
        
//        NSLog("%f %f ", size?.width, size?.height);
//        NSLog("%f %f %f %f", bound?.origin.x, bound?.origin.y, bound?.width, bound?.height);
//        [_scrollView.contentView scrollToPoint:NSMakePoint(0, ((NSView*)_scrollView.documentView).frame.size.height - _scrollView.contentSize.height)];

    }
    
}
