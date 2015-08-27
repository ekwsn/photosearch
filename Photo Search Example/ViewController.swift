//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Lok on 27/08/2015.
//  Copyright (c) 2015 Lok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       searchInstagramByHashtag("HongKong")
        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        for subview in self.scrollView.subviews {
        subview.removeFromSuperview()
        searchBar.resignFirstResponder()
            
        }
        
        searchInstagramByHashtag("\(searchBar.text)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func searchInstagramByHashtag (searchString: String) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=8da95193f9ec446c822501dd86b49623",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let dataArray = responseObject["data"] as? [AnyObject]{
                    
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            urlArray.append(imageURLString)
                        }
                    }
                    
                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    
                    for var i = 0; i < urlArray.count; i++ {
                        
                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth , imageWidth))     //1
                        imageView.setImageWithURL (NSURL(string: urlArray[i])!)                          //2
                        self.scrollView.addSubview(imageView)
                        
                        
                    }
                }
            },
            
            
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })

        
    }
}

