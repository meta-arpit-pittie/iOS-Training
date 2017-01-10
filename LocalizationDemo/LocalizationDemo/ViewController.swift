//
//  ViewController.swift
//  LocalizationDemo
//
//  Created by Gabriel Theodoropoulos on 30/10/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblMovieInformation: UILabel!
    
    @IBOutlet weak var imgFlag: UIImageView!
    
    @IBOutlet weak var tblMovieInformation: UITableView!
    
    @IBOutlet weak var btnMoviePicker: UIButton!
    
    var moviesData : NSArray?
    
    var selectedMovieIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make self the delegate and datasource of the tableview.
        tblMovieInformation.delegate = self;
        tblMovieInformation.dataSource = self;
        
        // Set the default selected movie index.
        selectedMovieIndex = 0
        
        // Load the movies data from the .plist file.
        loadMoviesData()
        
        // Set the flag image to the imageview.
        imgFlag.image = UIImage(named: "flag")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showMoviesList(_ sender: AnyObject) {
        let moviePicker = UIAlertController(title: "Movies List", message: "Pick a movie", preferredStyle: .actionSheet)
        
        for i in 0...(moviesData?.count)!-1 {
            let movieDataDictionary : NSDictionary = moviesData?.object(at: i) as! NSDictionary
            let currentMovieIndex = i
            let movieTitle = movieDataDictionary.object(forKey: "Movie Title") as! String
            
            let normalAction = UIAlertAction(title: movieTitle, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> Void in
                
                self.selectedMovieIndex = currentMovieIndex;
                self.tblMovieInformation.reloadData()
            })
            
            moviePicker.addAction(normalAction)
        }
        
        let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: "The Close button title"), style: UIAlertActionStyle.cancel) { (action: UIAlertAction!) -> Void in
            
            
        }
        
        moviePicker.addAction(closeAction)
        
        self.present(moviePicker, animated: true, completion: nil)
    }
    
    
    func loadMoviesData(){
        // Load the movies data. Note that we assume that the file always exists so we don't check it.
        let moviesDataPath = Bundle.main.path(forResource: "MoviesData", ofType: "plist")
        moviesData = NSArray(contentsOfFile: moviesDataPath!)
    }
    
    
    func getFormattedStringFromNumber(_ number: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "dsgd"
        //numberFormatter.string(from: number)
        //return numberFormatter.string(from: NSNumber(number))
        //return numberFormatter.string(from: NSNumber(number))!
    }
    
    
    func getFormattedStringFromDate(_ aDate: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: aDate)
    }
    
    
    
    //MARK - TableView method implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        let movieDataDictionary : NSDictionary = moviesData?.object(at: selectedMovieIndex!) as! NSDictionary
        
        switch indexPath.row{
        case 0:
            // Dequeue the proper cell.
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellTitle", for: indexPath) as UITableViewCell
            
            // Set the cell's title label text.
            cell.textLabel?.text = movieDataDictionary.object(forKey: "Movie Title") as? String
            
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellCategory", for: indexPath) as UITableViewCell
            
            let categoriesArray = movieDataDictionary.object(forKey: "Category") as! [String]
            var allCategories = String()
            for aCategory in categoriesArray{
                allCategories += NSLocalizedString(aCategory, comment: "The category of the movie") + " "
            }
            
            cell.textLabel?.text = allCategories
        
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellRating", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = getFormattedStringFromNumber(movieDataDictionary.value(forKey: "Rating") as! Double) + " / 10"
            
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellReleaseDate", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = getFormattedStringFromDate(movieDataDictionary.object(forKey: "Release Date") as! Date)
            
            
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellDuration", for: indexPath) as UITableViewCell
            
            let duration = movieDataDictionary.object(forKey: "Duration") as! Int
            cell.textLabel?.text = String(duration) + " " + NSLocalizedString("minutes", comment: "The minutes literal for the movie duration")
            
            
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellDirector", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = movieDataDictionary.object(forKey: "Director") as? String
            
            
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellStars", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = movieDataDictionary.object(forKey: "Stars") as? String
            
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellLink", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = movieDataDictionary.object(forKey: "Link") as? String
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7 {
            let movieDataDictionary : NSDictionary = moviesData?.object(at: selectedMovieIndex!) as! NSDictionary
            
            let link = movieDataDictionary.object(forKey: "Link") as! String
            
            UIApplication.shared.openURL(URL(string: link)!)
        }
    }
}

