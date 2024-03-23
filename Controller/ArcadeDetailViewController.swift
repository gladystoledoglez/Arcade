//
//  ArcadeDetailViewController.swift
//  FinalProject

import UIKit

class ArcadeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var platformTextLabel: UILabel!
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var releaseTextLabel: UILabel!
    
    var game: Arcade?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedGame = game {
            title = selectedGame.title
        }
        fetchGameDetails()
    }
    
    
    func fetchGameDetails() {
        guard let selectedGame = game else {
            return
        }
        
        if let gameID = selectedGame.id {
            let baseURL = "https://www.freetogame.com/api/game?id=\(gameID)"
            guard let url = URL(string: baseURL) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let gameDetail = try decoder.decode(ArcadeDetail.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.updateUI(with: gameDetail)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        } else {
            return
        }
    }
    
    func updateUI(with gameDetail: ArcadeDetail) {
        descriptionTextLabel.text = gameDetail.shortDescription
        platformTextLabel.text = gameDetail.platform
        categoryTextLabel.text = gameDetail.genre
        releaseTextLabel.text = gameDetail.releaseDate
        
        if let imageURL = URL(string: gameDetail.thumbnail) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
            }.resume()
        }
    }
}
