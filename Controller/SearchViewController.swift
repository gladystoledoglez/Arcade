//
//  SearchViewController.swift
//  FinalProject

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    var searchService = SearchService()
    var games: [Arcade] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        stackView.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            games = []
            tableView.reloadData()
            tableView.isHidden = true
            stackView.isHidden = false
        } else {
            Task {
                await searchGames(searchTerm: searchText)
            }
        }
    }
    
    func searchGames(searchTerm: String) async {
        do {
            var allGames = try await searchService.fetchGamesBySearchTerm(searchTerm: searchTerm)
            
            if !searchTerm.isEmpty {
                allGames = allGames.filter { game in
                    let searchTermLowerCase = searchTerm.lowercased()
                    let title = game.title.lowercased()
                    let category = game.genre.lowercased()
                    return title.contains(searchTermLowerCase) || category.contains(searchTermLowerCase)
                }
            }
            self.games = allGames
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = self.games.isEmpty
                self.stackView.isHidden = !self.games.isEmpty
            }
        } catch {
            print("Error fetching games: \(error)")
            self.tableView.isHidden = true
            self.stackView.isHidden = false
        }
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)

        let game = games[indexPath.row]
        cell.textLabel?.text = game.title
        cell.detailTextLabel?.text = "Category: \(game.genre)"

        if let imageURL = URL(string: game.thumbnail) {
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }.resume()
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedGame = self.games[indexPath.row]
        performSegue(withIdentifier: "showArcadeDetail", sender: selectedGame)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArcadeDetail", let gameDetailVC = segue.destination as? ArcadeDetailViewController, let selectedGame = sender as? Arcade {
            gameDetailVC.game = selectedGame
        }
    }
}
