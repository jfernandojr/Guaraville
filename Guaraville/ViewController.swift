//
//  ViewController.swift
//  Guaraville
//
//  Created by MacBook Air on 2015. 10. 24..
//  Copyright (c) 2015년 MacBook Air. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FilterViewDelegate {
    
    @IBOutlet var scroll: UIScrollView?
    @IBOutlet var imgTitle: UIImageView?
    @IBOutlet var btnHelp: UIButton?
    @IBOutlet var btnRefresh: UIButton?
    @IBOutlet var btnFiter: UIButton?
    
    var popViewController : HelpUIView?
    var bLoaded : Bool = false
    var nMaxQuara = 0;
    
    var arrJson = NSMutableArray()
    var filterView : FilterUIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loadJson()
        //loadJsonDataInBackground()
        let thread = NSThread(target: self, selector: "loadJsonDataFromUrl", object: nil)
        thread.start()
        IJProgressView.shared.showProgressView(view)
        imgTitle?.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(153) / 255.0, blue: CGFloat(204) / 255.0, alpha: CGFloat(1))
        
        btnHelp?.addTarget(self, action: "onClickHelp:", forControlEvents: UIControlEvents.TouchDown)
        btnRefresh?.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.TouchDown)
        btnFiter?.addTarget(self, action: "onFilter:", forControlEvents: UIControlEvents.TouchDown)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadJsonDataInBackground(){
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                let url: NSURL = NSURL(string: "http://45.55.76.235/reservas/get-reservas")!
                let resultsData = try? NSData(contentsOfURL: url, options: NSDataReadingOptions.DataReadingUncached)
                //let resultsString:NSString = NSString(data: resultsData!, encoding: NSUTF8StringEncoding)!
                
                self.startParsing(resultsData!)
                self.buildList()
                self.bLoaded = true
                
            }
        }
    }
    func close() {
        IJProgressView.shared.hideProgressView()
    }
    func setCloseTimer() {
        //let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "close", userInfo: nil, repeats: false)
        IJProgressView.shared.hideProgressView()
    }
    func loadJsonDataFromUrl()
    {
        let url: NSURL = NSURL(string: "http://45.55.76.235/reservas/get-reservas")!
        
        /*
        let resultsData = try? NSData(contentsOfURL: url, options: NSDataReadingOptions.DataReadingUncached)
        self.startParsing(resultsData!)
        self.buildList()
        self.bLoaded = true*/
        
        
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let resultsData = data where error == nil else { return }
                print("Finished downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
                self.startParsing(resultsData)
                self.buildList()
                self.bLoaded = true
                self.setCloseTimer()
            }
        }
        
    }
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    func startParsing(data :NSData) {
       
        /*let arrItems: NSArray = (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSArray*/
        var arrItems : NSArray!
        do {
            arrItems = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            // use anyObj here
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        for var i = 0; i < arrItems.count; i++ {
            arrJson.addObject(arrItems.objectAtIndex(i))
        }
        
    }
    func clearList(){
        if self.bLoaded
        {
            scroll?.subviews.map { $0.removeFromSuperview() }
        }
    }
    func buildList(){
       
       /* let subViews = self.scroll?.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }*/
        
        var temp:CGFloat = 0
        let count = arrJson.count
        
        
        for i in 1 ... count  {
            var view: JsonRowUIView!
            view = loadRowViewFromNib()
            temp = CGFloat(130 * (i - 1))
            view.frame = CGRectMake(0, temp, self.view.bounds.width, 120)
            
            let itemJson:NSMutableDictionary = arrJson.objectAtIndex(i-1) as! NSMutableDictionary
            
            let str1 = itemJson["court"] as! Int
            let str2 = itemJson["lot"] as! Int
            let str3 = itemJson["area"] as! String
            let str4 = itemJson["price"] as! String
            let status = itemJson["status"] as! Int
            
            view.setInfo(String(str1), strText2:String(str2), strText3:str3, strText4:str4, status:status)
            scroll?.addSubview(view)
            
            if nMaxQuara < str1
            {
                nMaxQuara = str1
            }
            
        }
        scroll?.contentSize = CGSizeMake(self.view.frame.size.width, temp + 120)
    }
    func loadJson(){
        
    
        var temp:CGFloat = 0
        for i in 1 ... 8 {
            var view: UIView!
            view = loadViewFromNib()
            temp = CGFloat(130 * (i - 1))
            view.frame = CGRectMake(0, temp, self.view.bounds.width, 120)
            scroll?.addSubview(view)
            
        }
        scroll?.contentSize = CGSizeMake(self.view.frame.size.width, temp + 120)
    
    }
    func loadViewFromNib()->UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib =  UINib(nibName: "JsonRowView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    func loadRowViewFromNib()->JsonRowUIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib =  UINib(nibName: "JsonRowView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! JsonRowUIView
        return view
    }
    func onClickHelp(sender:UIButton){
        self.popViewController = HelpUIView(nibName: "HelpView", bundle: nil)
        self.popViewController?.showInView(self.view, animated: true)
       
    }
    func onRefresh(sender: UIButton)
    {
        if self.bLoaded{
            clearList()
        self.bLoaded = false
        let thread = NSThread(target: self, selector: "loadJsonDataFromUrl", object: nil)
        thread.start()
        IJProgressView.shared.showProgressView(view)
        }
    }
    func onFilter(sender: UIButton)
    {
        if self.bLoaded{
            self.filterView = FilterUIView(nibName: "FilterView", bundle: nil)
            self.filterView?.delegate = self
            self.filterView?.showInView(self.view, animated: true)
        }
    }
    func filterSelected(nFilter: Int)
    {
        clearList()
        if nFilter == 0 || nMaxQuara < nFilter
        {
            buildList()
            return
        }
        var temp:CGFloat = 0
        let count = arrJson.count
        var index : Int = 0
        
        for i in 1 ... count  {
            var view: JsonRowUIView!
            view = loadRowViewFromNib()
            temp = CGFloat(130 * index)
            view.frame = CGRectMake(0, temp, self.view.bounds.width, 120)
            
            let itemJson:NSMutableDictionary = arrJson.objectAtIndex(i-1) as! NSMutableDictionary
            
            let str1 = itemJson["court"] as! Int
            let str2 = itemJson["lot"] as! Int
            let str3 = itemJson["area"] as! String
            let str4 = itemJson["price"] as! String
            let status = itemJson["status"] as! Int
            if str1 == nFilter
            {
                view.setInfo(String(str1), strText2:String(str2), strText3:str3, strText4:str4, status:status)
                scroll?.addSubview(view)
                index++
                
            }
        }
        scroll?.contentSize = CGSizeMake(self.view.frame.size.width, temp)
    }

    
}

