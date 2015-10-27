//
//  JsonRowUIView.swift
//  Guaraville
//
//  Created by Fernando Júnior on 2015. 10. 24..
//

import Foundation
import UIKit

@IBDesignable
class JsonRowUIView : UIView {
    
    var view: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    
    @IBOutlet weak var imgStatus: UIImageView!
    
    func setInfo (strText1:String, strText2: String, strText3:String, strText4:String, status:Int){
        text1.text = strText1
        text2.text = strText2
        text3.text = strText3
        text4.text = strText4
        
        if status == 1
        {
            imgStatus?.backgroundColor = UIColor.whiteColor()
        }
        else if status == 2
        {
            imgStatus?.backgroundColor = UIColor.yellowColor()
        }
        else if status == 3
        {
            imgStatus?.backgroundColor = UIColor.redColor()
        }
    }
}
