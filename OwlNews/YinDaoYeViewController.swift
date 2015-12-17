//
//  YinDaoYeViewController.swift
//  OwlNews
//
//  Created by MrOwl on 15/11/6.
//  Copyright (c) 2015年 MrOwl. All rights reserved.
//

import UIKit

class YinDaoYeViewController: UIViewController ,UIScrollViewDelegate{

    let scorllViewer = UIScrollView()
    let pageControl = UIPageControl()
    let btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YinDaoYe()
        // Do any additional setup after loading the view.
    }

    
    func YinDaoYe(){
        
        //声明一个PageControl对象
        //设置PageControl的位置
        pageControl.center = CGPointMake(self.view.frame.width/2, self.view.frame.height - 50)
        //设置PageControl的页面数
        pageControl.numberOfPages = 4
        //设置PageControl在当前页面时的颜色
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        //设置PageControl在非当前页面的颜色
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        //为PageControl添加标签
        pageControl.addTarget(self, action: "scrollViewDidEndDecelerating", forControlEvents: UIControlEvents.ValueChanged)
        
        //声明一个ScorllView对象
        
        //scorllViewer.frame.size = CGSizeMake((self.view.frame.width * 4), self.view.frame.height)
        scorllViewer.frame = self.view.bounds
        scorllViewer.contentSize = CGSizeMake((self.view.frame.width * 4), 0)
        scorllViewer.pagingEnabled = true
        scorllViewer.bounces = false //弹簧力的值
        scorllViewer.showsHorizontalScrollIndicator = true //不显示水平滑动条
        scorllViewer.delegate = self
        
        for(var i=0;i<4;i++)
        {
            var image = UIImage(named: "Welcome\(i+1)")
            var imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            imageView.image = image
            var frame = imageView.frame
            frame.origin.x = CGFloat(i) * self.view.frame.width
            imageView.frame = frame
            scorllViewer.addSubview(imageView)
        }
        self.view.addSubview(scorllViewer)
        self.view.addSubview(pageControl)
    }
    
    //滑动结束后进行的函数
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var index = Int(scorllViewer.contentOffset.x/self.view.frame.size.width)
        pageControl.currentPage = index
        if(index == 3)
        {
            self.btn.frame = CGRectMake(self.view.frame.width * 3, self.view.frame.height, self.view.frame.width, 50)
            self.btn.setTitle("进入Mr.Owl的专属新闻APP", forState: UIControlState.Normal)
            self.btn.titleLabel?.font = UIFont.systemFontOfSize(20)                             //按钮文字字体
            self.btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)   //按钮文字显示的颜色
            self.btn.backgroundColor = UIColor.purpleColor()
            self.btn.alpha = 0
            self.btn.addTarget(self, action: "btnToHomeClick:", forControlEvents: UIControlEvents.TouchUpInside)
            UIView.animateWithDuration(1.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.btn.frame = CGRectMake(self.view.frame.width * 3, self.view.frame.height - 120, self.view.frame.width, 50)
                self.btn.alpha = 1
                self.scorllViewer.addSubview(self.btn)
            }, completion: nil)
        }
    }

    func btnToHomeClick(button: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let HomePage = storyBoard.instantiateViewControllerWithIdentifier("Navigation") as! UIViewController
        presentViewController(HomePage, animated: true, completion: nil)
        //performSegueWithIdentifier("YinDaoEnd", sender: self)
        //presentViewController(UINavigationController(), animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
