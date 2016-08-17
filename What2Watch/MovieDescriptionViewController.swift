//
//  MovieDescriptionViewController.swift
//  What2Watch
//
//  Created by Dustin Allen on 8/16/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage
import UIActivityIndicator_for_SDWebImage

class MovieDescriptionViewController: UIViewController {
    
    @IBOutlet var btnBack: UIButton?
    @IBOutlet var poster: UIImageView!
    @IBOutlet var lblMovieTitle: UILabel!
    @IBOutlet var lblGenere: UILabel!
    @IBOutlet var lblYear: UILabel!
    
    //static var imdbID: String = ""
    var movieDetail:[String:String]?
    var movieFullDetail:[String:String]?
    
    override func viewDidLoad() {
        
        
        //let imdbIDPoster : String = MovieDescriptionViewController.imdbID
        //let posterURL = "http://img.omdbapi.com/?i=\(imdbIDPoster)&apikey=57288a3b&h=1000"
        //poster.image = posterURL
        
        lblMovieTitle.text = "\( movieDetail?["movieTitle"] ?? "" )"
        lblGenere.text = "Genere : \( movieDetail?["genre"] ?? "" )"
 
        let posterURL = "http://img.omdbapi.com/?i=\(movieDetail?["imdbID"] ?? "")&apikey=57288a3b&h=1000"
        let posterNSURL = NSURL(string: "\(posterURL)")
        self.poster.setImageWithURL(posterNSURL, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.AllowInvalidSSLCertificates, completed: { (imgPoster, error, cacheType, urlPoster) in
                if error != nil {
                    print(error)
                }
            }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        
        CommonUtils.sharedUtils.showProgress(self.view, label: "Please wait..")
        let movieFullDetailURL = "http://www.omdbapi.com/"  //http:// www.omdbapi.com/?i=(*imdbID*)&plot=short&r=json
        Alamofire.request(.GET, movieFullDetailURL, parameters: ["i": movieDetail?["imdbID"] ?? "", "apikey":"57288a3b", "plot":"short", "r":"json"])
            .responseJSON { response in
                
                debugPrint(response)
                CommonUtils.sharedUtils.hideProgress()
                
                if let JSON = response.result.value as? [String:String] {
                    self.movieFullDetail = JSON
                    print("Success with JSON: \(JSON)")
                    
                    if let Year = JSON["Year"] {
                        self.lblYear.text = "Year: \(Year)"
                    }
                }
                
        }
        
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
