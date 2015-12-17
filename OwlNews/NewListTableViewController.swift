//
//  NewListTableViewController.swift
//  OwlNews
//
//  Created by MrOwl on 15/10/18.
//  Copyright (c) 2015年 MrOwl. All rights reserved.
//

import UIKit

class NewListTableViewController: UITableViewController {

    @IBOutlet weak var HeadLineImageView: UIImageView!
    @IBOutlet weak var HeadLineLable: UILabel!
    
    let APIURL = "http://qingbin.sinaapp.com/api/lists?ntype=%E5%9B%BE%E7%89%87&pageNo=1&pagePer=10&list.htm"                         //新闻内容的请求APIURL
    
    var DataSource = [NewsItem]()
    
    
    //窗体加载函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("FirstLoad"))
        {
            presentViewController(YinDaoYeViewController(), animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLoad")
        }
        else
        {
            XiaLaShuaXin()
            LoadData()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLoad")
        }

        
        
    }

    
    
    //加载新闻信息
    func LoadData(){
        let url = NSURL(string: APIURL)                     //实例化NSURL对象
        let loadRequest = NSURLRequest(URL: url!)           //加载请求
        let loadQueue = NSOperationQueue()                  //加载队列
        NSURLConnection.sendAsynchronousRequest(loadRequest, queue: loadQueue)
            {
                (response, data, error) -> Void in
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves , error: nil)as! NSDictionary
                //解析json并赋值给DatSource
                let newsDataSourceItem = json["item"] as! NSArray
                var currentNewsData = [NewsItem]()
            
                for currentNews in newsDataSourceItem
                {
                    let newsItem = NewsItem()
                    newsItem.NewsTitle = currentNews["title"] as! NSString
                    newsItem.NewsID = currentNews["id"] as! NSString
                    newsItem.NewsThumb = currentNews["thumb"] as! NSString
                    currentNewsData.append(newsItem)
                }
           
                self.DataSource = currentNewsData
                self.loadHeaderInfo()
                dispatch_async(dispatch_get_main_queue()
                    , {self.tableView.reloadData()})
        }
    }
    
    
    //下拉刷新
    func XiaLaShuaXin(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "撸一下，就更新")
        refreshControl.addTarget(self, action: "ShuaXinData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func ShuaXinData(){
        refreshControl?.beginRefreshing()
        LoadData()
        refreshControl?.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    //设置行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return DataSource.count
    }

    //为每行的cell赋值
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FirstReusingidentifiers")
        cell.textLabel?.text = DataSource[indexPath.row].NewsTitle as? String
        cell.detailTextLabel?.text = DataSource[indexPath.row].NewsID as? String
        
        //设置Tableview的默认图片
        cell.imageView?.image = UIImage(named: "apple")
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let url = NSURL(string: ((DataSource[indexPath.row].NewsThumb) as? String)!)
        let request = NSURLRequest(URL: url!)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView!.image = image
            })
        }
        
        return cell
    }
    
    //单击行事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("CellPush", sender: self)
    }
    
    //跳转前为下一个界面的变量赋值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判断是哪个过渡
        if(segue.identifier == "CellPush"){
            //判断点击的是哪一行
            let selectIndex = self.tableView.indexPathForSelectedRow()
            //将该行的NewsID赋值给新闻页面的对应的变量
            let webViewController = segue.destinationViewController as! ViewController
            webViewController.DetialID = DataSource[selectIndex!.row].NewsID
        }
        else if(segue.identifier == "HeadLinePush"){
            let webViewController = segue.destinationViewController as! ViewController
            webViewController.DetialID = DataSource[0].NewsID
    
        }
    }
    
    //设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeTranslation(1, 1, 1)
        })
    }
    
    
    //加载头条信息
    func loadHeaderInfo(){
        let url = NSURL(string: DataSource[0].NewsThumb as String)
        let request = NSURLRequest(URL: url!)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.HeadLineImageView.image = UIImage(data: data!)
                self.HeadLineLable.text = self.DataSource[0].NewsTitle as String
            })
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
