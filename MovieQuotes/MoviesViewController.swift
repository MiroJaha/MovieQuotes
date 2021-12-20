//
//  ViewController.swift
//  MovieQuotes
//
//  Created by admin on 20/12/2021.
//

import UIKit
import CCAutocomplete

class MoviesViewController: UIViewController {
    
    private let key = "ab63c21c51099016696ec8784807ecda"
    var search = "die hard"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollcetionView: UICollectionView!
    
    var moviesDetailsList = [Result]()
    var moviesImageList = [Int : UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollcetionView.dataSource = self
        moviesCollcetionView.delegate = self
        gettingDataFromAPI()
    }
    
    func gettingDataFromAPI(){
        //Replaceing Spaces With Somthing API can Read
        search = search.replacingOccurrences(of: " ", with: "%20")
        // specify the url that we will be sending the GET request to
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(key)&query=\(search)&page=1")
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(MoviesAPIModel.self, from: data!)
                
                self.moviesDetailsList = decoded.results
                
                DispatchQueue.main.async {
                    self.moviesCollcetionView.reloadData()
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        })
        task.resume()
    }
    
    func MovieImage(movieID: Int) -> UIImage {
        for movieImage in moviesImageList {
            if (movieImage.key == movieID) {
                return movieImage.value
            }
        }
        if let filePath = Bundle.main.path(forResource: "defaultImage", ofType: "jpeg"),
           let defaultImage = UIImage(contentsOfFile: filePath) {
            return defaultImage
        }
        let errorImage = UIImage()
        return errorImage
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesDetailsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movieDetailsLabel.text = moviesDetailsList[indexPath.row].overview
        self.present(movieDetailsViewController, animated: true, completion: nil)
    }
}
