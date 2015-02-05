//
//  MoviesViewController.swift
//  Stale Nightshade Swift
//
//  Created by Kevin Farst on 1/22/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var moviesTab: UITabBarItem!
    @IBOutlet weak var dvdsTab: UITabBarItem!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies: [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    var movieUrls = MovieUrls()
    
    struct MovieUrls {
        let boxOfficePath: String
        let dvdsPath: String
        var selected: String?
        
        init () {
            boxOfficePath = "movies/box_office"
            dvdsPath = "dvds/current_releases"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tabBar.delegate = self
        
        self.movieUrls.selected = movieUrl(self.movieUrls.boxOfficePath)
        
        fetchMovies()

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refreshMovies", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.tabBar.selectedItem = moviesTab
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
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        var runTime = movie["runtime"] as Int
        var ratings = movie["ratings"] as NSDictionary
        var criticRating = ratings["critics_score"] as Int
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        cell.ratingPercentageLabel.text = "\(criticRating)%"
        cell.ratingLabel.text = movie["mpaa_rating"] as? String
        cell.runningTimeLabel.text = "\(runTime) mins"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "MovieDetailSegue" {
           var indexPath = self.tableView.indexPathForSelectedRow()!
           var movie = movies[indexPath.row] as NSDictionary
           (segue.destinationViewController as MovieDetailViewController).movie = movie
        }
    }
    
    func refreshMovies() {
        fetchMovies(showProgess: false)
    }
    
    func fetchMovies(showProgess: Bool = true) {
        let showProgressView = showProgess
        
        if showProgressView {
            SVProgressHUD.show()
        }
        
        var request = NSURLRequest(URL: NSURL(string: self.movieUrls.selected!)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error == nil) {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                self.movies = object["movies"] as [NSDictionary]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                self.searchBar.hidden = true
                self.networkErrorLabel.hidden = false
            }
            
            if showProgressView {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func movieUrl(type: String) -> String {
      return "http://api.rottentomatoes.com/api/public/v1.0/lists/\(type).json?apikey=tax9gwc3xnks8xpkdhamyfke"
    }
    
    func searchUrl(searchText: String) -> String {
        return "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(searchText)&page_limit=15&apikey=axku2sndnpg2d6dhjw59wj3d&country=us"
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if (item.title == "Movies") {
            self.navigationItem.title = "Movies"
            self.movieUrls.selected = movieUrl(self.movieUrls.boxOfficePath)
        } else {
            self.navigationItem.title = "DVDs"
            self.movieUrls.selected = movieUrl(self.movieUrls.dvdsPath)
        }
        
        fetchMovies()
    }
    
    func searchMovies(searchText: String) {
        self.movieUrls.selected = searchUrl(searchText)
        fetchMovies()
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
        if searchText.isEmpty {
            switch self.tabBar.selectedItem! {
            case moviesTab:
                self.movieUrls.selected = movieUrl(self.movieUrls.boxOfficePath)
            case dvdsTab:
                self.movieUrls.selected = movieUrl(self.movieUrls.dvdsPath)
            default:
                self.movieUrls.selected = movieUrl(self.movieUrls.boxOfficePath)
            }
            
            fetchMovies()
        } else {
            searchMovies(searchText)
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
