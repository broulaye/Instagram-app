//
//  ViewController.swift
//  instagram2
//
//  Created by Vincent Le on 1/28/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var feed: [NSDictionary]?
    var path:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataFromNetwork()
    }
    func loadDataFromNetwork() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.feed = responseDictionary["data"] as? [NSDictionary]
                            //print(responseDictionary["data"])
                            
                            
                    }
                }
        });
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let vc = segue.destinationViewController as! PhotoDetailsViewController
        
            let photo = feed?[indexPath!.row]
            
            let path = photo!.valueForKeyPath("images.low_resolution.url") as? String
            let url = NSURL(string: path!)
            vc.photo = url
        
        
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        
                
           

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedCell
        
        
        /*
        let image = photo["response"] as? NSDictionary
        let counter =  image!["standard_resolution"]!["url"] as! String
        */
        if let photo = feed?[indexPath.row]{
            path = photo.valueForKeyPath("images.low_resolution.url") as? String
            let url = NSURL(string: path!)
            print(url)
            cell.photoView.setImageWithURL(url!)
        }
        else {
            print(feed?[indexPath.row])
        }
        
 

        return cell
    }
}
