//
//  ViewController.swift
//  Tab
//
//  Created by vyshu k on 09/05/17.
//  Copyright © 2017 vyshu k. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var Discoverlabel: UILabel!
    @IBOutlet weak var SavedLabel: UILabel!
    @IBOutlet weak var AppsLabel: UILabel!
    @IBOutlet weak var SearchLabel: UILabel!
    @IBOutlet weak var LiveLabel: UILabel!
    @IBOutlet weak var SettingsLAbel: UILabel!
    @IBOutlet weak var EpgLabel: UILabel!
    @IBOutlet weak var ExitLabel: UILabel!
    @IBOutlet weak var timedateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var HighlightView: UIView!
    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var collect2: UICollectionView!
    
    let reuse1 = "MenuCell"
    let reuse2 = "cell2"
    
    var types = ["ACTION","THRILLER","COMEDY","HORROR","OTHER"]
    var images = ["Action.jpg","Thriller.jpg","Comedy.jpg","horror.jpg","other.jpg"]
    let baseURL = "http://api.themoviedb.org/3/movie/popular?api_key=ff743742b3b6c89feb59dfc138b4c12f"
    var moviesfeat = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = .right
        HighlightView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = .left
        HighlightView.addGestureRecognizer(swipeLeft)

        
        time()
        date()
        downloadData()
    }

    
    func date()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        formatter.dateStyle = .long
        let result = formatter.string(from: date)
        timedateLabel.text = "\(result)"
    }
    
    func time()
    {
        let formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: Date())
        timeLabel.text = dateString
    }
    
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                HighlightView.frame.origin.x += 40
                print("right")
            
                case UISwipeGestureRecognizerDirection.left:
                HighlightView.frame.origin.x -= 40
                print("left")
            
                default:
                break
             }
           }
        }
    
    func downloadData(){
        
        let url = NSURL(string: baseURL)!
        let request = NSURLRequest(url: url as URL)
        let session = URLSession.shared
        // let task = session.dataTask(with: request) { (data, response ,errror) -> Void in
        let task = session.dataTask(with: request as URLRequest!){ (data, response ,error) -> Void in
            
            
            if error != nil {
                print(error.debugDescription)
                }
                
            else{
                do{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject>
                    
                    // Parsing data
                    
                    if let results = dict!["results"] as? [Dictionary<String,AnyObject>] {
                        
                       print(results)
                        
                        for obj in results {
                            let movie = Movie(movieDict: obj)
                            self.moviesfeat.append(movie)
                        }
                        
                        DispatchQueue.main.async(){
                            
                            self.collect2.reloadData()
                        }
                        
                    }
                }
                catch{
                    
                }
                
                
            }
            
        }
        task.resume()
    }
    


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.collect)
        {
        return types.count
        }
        
        else
        {
            return moviesfeat.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if (collectionView == self.collect)
        {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse1, for: indexPath) as! CollectionViewCell
        let imagetype = UIImage(named: images[indexPath.row])
        cell.Image.image = imagetype
        cell.typelabel.text = types[indexPath.row]
        return cell
        }

      if (collectionView == self.collect2)
      {
            let Featured : FeaturedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse2, for: indexPath) as! FeaturedCollectionViewCell
            let movie  = moviesfeat[indexPath.row]
            Featured.configureCell(movie: movie)
            return Featured
       }
        
      return UICollectionViewCell()
        
    }
}
