//
//  HelpUIView.swift
//  Guaraville
//
//  Created by Fernando Júnior on 2015. 10. 25..
//

import Foundation

import UIKit

@IBDesignable
class HelpUIView : UIViewController {
    
    @IBOutlet var viewPop: UIView?
    
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
    }
    
    func showInView(aView: UIView!, animated: Bool)
    {
        aView.addSubview(self.view)
        self.view.frame = CGRectMake(0, 0, aView.bounds.width, aView.bounds.height)
        /*logoImg!.image = image
        messageLabel!.text = message*/
        if animated
        {
            self.showAnimate()
        }
    }
    func showInView(aView: UIView!, withImage image : UIImage!, withMessage message: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        self.view.frame = CGRectMake(0, 0, aView.bounds.width, aView.bounds.height)
        /*logoImg!.image = image
        messageLabel!.text = message*/
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
    
    @IBAction func closePopup(sender: AnyObject) {
        self.removeAnimate()
    }
    
    
   
}
