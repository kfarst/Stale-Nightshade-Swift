//
//  MovieDetailViewController.swift
//  Stale Nightshade Swift
//
//  Created by Kevin Farst on 1/27/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["profile"] as String
        var url = NSURL(string: posterUrl)
        
        self.backgroundImage.setImageWithURL(url)
        
        //if let data = NSData(contentsOfURL: url!) {
        //    self.view.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
        //}
        // Do any additional setup after loading the view.
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
