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
    @IBOutlet weak var movieSummaryView: UIView!
    @IBOutlet weak var titeLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    var movie: NSDictionary!
    var summaryViewStartingPoint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["profile"] as String
        var url = NSURL(string: posterUrl)
        
        self.backgroundImage.setImageWithURL(url)
        
        let originalUrl = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori")

        url = NSURL(string: originalUrl)
        
        self.backgroundImage.setImageWithURL(url)
        
        self.titeLabel.text = movie["title"] as? String
        self.synopsisLabel.text = movie["synopsis"] as? String
        self.synopsisLabel.sizeToFit()
        self.summaryViewStartingPoint = CGFloat(self.movieSummaryView.center.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dragMovieDetailView(sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(sender.view!)
        var translation = sender.translationInView(self.view)
        var posterCenter = CGFloat(self.backgroundImage.center.y)
        
        if (sender.view!.center.y < self.summaryViewStartingPoint && sender.view!.center.y > posterCenter) {
            sender.view!.center = CGPointMake(sender.view!.center.x, sender.view!.center.y + translation.y)
        } else if (sender.view!.center.y >= self.summaryViewStartingPoint && (sender.view!.center.y + translation.y) < self.summaryViewStartingPoint) {
            sender.view!.center = CGPointMake(sender.view!.center.x, sender.view!.center.y + translation.y)
        } else if (sender.view!.center.y <= posterCenter && (sender.view!.center.y + translation.y) > posterCenter) {
            sender.view!.center = CGPointMake(sender.view!.center.x, sender.view!.center.y + translation.y)
        }
        
        sender.setTranslation(CGPointZero, inView: self.view)
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
