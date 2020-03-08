//
//  ImageViewController.swift
//  FastViewer
//
//  Created by chenmingjin on 2020/2/27.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController {

    @IBOutlet weak var viewHeightConstraint0: NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint0: NSLayoutConstraint!
    @IBOutlet weak var image0: NSImageView!
    @IBOutlet weak var clipView0: CenteringClipView!
    
    
    // 定义zoomFactor变量，表示图片的缩放比例
    var zoomFactor:CGFloat = 1.0 {
        // 当变量发生变化是，执行didSet
        didSet {
            // 如果图像为空，马上返回
            guard image0.image != nil else {
                return
            }
            
            // 根据zoomFactor改变图像clip view的尺寸
            // Setting the the constraint constants for the height and the width will automatically invalidate the layout for the view and force a re-draw
            viewHeightConstraint0.constant = image0.image!.size.height * zoomFactor;
            viewWidthConstraint0.constant = image0.image!.size.width * zoomFactor;
            NSLog("缩放比例: %f", zoomFactor);
        }
    }
    
    @IBAction func zoomIn(sender: NSToolbarItem?) {
        NSLog("zoomIn");
        if zoomFactor + 0.1 > 4 {
            zoomFactor = 4;
        } else if zoomFactor == 0.05 {
            zoomFactor = 0.1;
        } else {
            zoomFactor += 0.1;
        }
    }
    
    @IBAction func zoomOut(sender: NSToolbarItem?) {
        if zoomFactor - 0.1 < 0.05 {
            zoomFactor = 0.05;
        } else {
            zoomFactor -= 0.1;
        }
    }
    
    @IBAction func zoomToActual(sender: NSToolbarItem?) {
        zoomFactor = 1.0;
    }
    
    @IBAction func zoomToFit(sender: NSToolbarItem?) {
        guard image0!.image != nil else {
            return;
        }
        let imSize = image0!.image!.size;
        var clipSize = clipView0.bounds.size;
        guard imSize.width > 0 && imSize.height > 0 && clipSize.width > 0 && clipSize.height > 0 else {
            return;
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
            zoomFactor = clipSize.height / imSize.height;
        } else {
            zoomFactor = clipSize.width / imSize.width;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.zoomToActual(sender: nil);
    }

    
}
