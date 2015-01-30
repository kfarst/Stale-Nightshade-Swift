//
//  MoviesViewController.swift
//  Stale Nightshade Swift
//
//  Created by Kevin Farst on 1/22/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        SVProgressHUD.show()
        
        fetchMovies(self)
        
        SVProgressHUD.dismiss()

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "fetchMovies:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        
        return cell
    }
    
    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //    
    //    var selectedMovie = movies[indexPath.row]
    //    
    //    let destinationVC = MovieDetailViewController()
    //    destinationVC.movie = selectedMovie
    //    
    //    destinationVC.performSegueWithIdentifier("MovieDetailSegue", sender: self)
    //}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "MovieDetailSegue" {
           var indexPath = self.tableView.indexPathForSelectedRow()!
           var movie = movies[indexPath.row] as NSDictionary
           (segue.destinationViewController as MovieDetailViewController).movie = movie
        }
    }
    
    
    func fetchMovies (sender: AnyObject?) {
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=tax9gwc3xnks8xpkdhamyfke"
        var request = NSURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = object["movies"] as [NSDictionary]
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
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
