//
//  ViewController.swift
//  OwlNews
//
//  Created by MrOwl on 15/10/18.
//  Copyright (c) 2015年 MrOwl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var NewsWebView: UIWebView!
    
    let DetialUrl = "http://qingbin.sinaapp.com/api/html/"
    var DetialID = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadNewsByURL( DetialUrl + (DetialID as String) + ".html" )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func LoadNewsByURL(url: String){
        let Url = NSURL(string: url)
        let request = NSURLRequest(URL: Url!)
        NewsWebView.loadRequest(request)
    }

}

