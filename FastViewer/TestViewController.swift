//
//  TestViewController.swift
//  FastViewer
//
//  Created by 陈铭津 on 2020/3/8.
//  Copyright © 2020 chenmingjin. All rights reserved.
//

import Cocoa

class TestViewController: NSViewController {

    @IBOutlet weak var clipView: NSClipView!
    @IBOutlet weak var testView: NSView!
    @IBOutlet weak var hslider: NSSlider!
    @IBOutlet weak var vslider: NSSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        hslider.minValue = 0;
        hslider.maxValue = Double(NSWidth(testView.frame));
        
        vslider.minValue = 0;
        vslider.maxValue = Double(NSHeight(testView.frame));
    }
    
    @IBAction func slider_v(_ sender: NSSlider) {
        let rect: CGRect = clipView.bounds;
        let bounds = NSMakeRect(
            CGFloat(sender.doubleValue),
                      NSMinY(rect),
                      NSWidth(rect),
                      NSHeight(rect)
                     )
        NSLog("slider %f %f %f", CGFloat(sender.doubleValue), CGFloat(sender.minValue), CGFloat(sender.maxValue))
        
        clipView.setValue(bounds, forKey: "bounds")
    }
    
    @IBAction func slider_h(_ sender: NSSlider) {
        let rect: CGRect = clipView.bounds;
        let bounds = NSMakeRect(
                    NSMinX(rect),
                    CGFloat(sender.doubleValue),
                    NSWidth(rect),
                    NSHeight(rect)
                        )
        NSLog("slider %f %f %f", CGFloat(sender.doubleValue), CGFloat(sender.minValue), CGFloat(sender.maxValue))
        
        clipView.setValue(bounds, forKey: "bounds")
    }
}
