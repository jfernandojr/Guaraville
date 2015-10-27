//
//  FilterUIView.swift
//  Guaraville
//
//  Created by MacBook Air on 2015. 10. 27..
//  Copyright © 2015년 MacBook Air. All rights reserved.
//

import Foundation
import UIKit


protocol FilterViewDelegate{
    func filterSelected(nFilter: Int)
}

@IBDesignable
class FilterUIView : UIViewController {
    @IBOutlet var viewPop: UIView?
    @IBOutlet var btnOk: UIButton?
    @IBOutlet var btnCancel: UIButton?
    @IBOutlet var txtFilter: UITextField?
    @IBOutlet var switchFilter: UISwitch?

    var delegate: FilterViewDelegate! = nil

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        self.viewPop?.layer.cornerRadius = 5
        self.viewPop?.layer.shadowOpacity = 0.8
        self.viewPop?.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        btnOk?.addTarget(self, action: "onFilter:", forControlEvents: UIControlEvents.TouchDown)
        switchFilter?.addTarget(self, action: "onSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)

    }
    func showInView(aView: UIView!, animated: Bool)
    {
        aView.addSubview(self.view)
        self.view.frame = CGRectMake(0, 0, aView.bounds.width, aView.bounds.height)
        if animated
        {
            self.showAnimate()
        }
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.removeAnimate()
    }

    
    func onFilter(sender: UIButton)
    {
        let str:String = (txtFilter?.text)!
        let nFilter = Int(str)
        if nFilter == nil
        {
            self.removeAnimate()
            return
        }
        self.delegate.filterSelected(nFilter!)
        self.removeAnimate()
    }
    func onSwitchChanged(sender: UISwitch)
    {
        if (switchFilter?.on
         != nil){
            self.delegate.filterSelected(0)
            self.removeAnimate()

        }
    }
    
    
}