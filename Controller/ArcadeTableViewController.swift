//
//  ArcadeTableViewController.swift
//  FinalProject

import UIKit

class ArcadeTableViewController: UITableViewController {
    
    var games: [Arcade] = []
    let gameService = ArcadeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await fetchGames()
        }
    }
    
    private func fetchGames() async {
        do {
            let gamesData = try await gameService.fetchGames()
            self.games = gamesData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching games: \(error.localizedDescription)")
            
            if let apiError = error as? APIError {
                var errorMessage = ""
                
                switch apiError {
                case .noInternetConnection:
                    errorMessage = "Sem conexão de internet. Verifique sua conexão e tente novamente."
                case .serverError(let statusCode):
                    errorMessage = "Erro no servidor (Status\(statusCode)). Tente novamente mais tarde."
                }
                let alert = UIAlertController(title: "Erro", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Erro", message: "Ocorreu um error desconhecido. Tente novamente mais tarde", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcadeCell", for: indexPath)
        let game = games[indexPath.row]
        cell.textLabel?.text = game.title
        cell.detailTextLabel?.text = "Publisher \(game.publisher)"

        if let imageURL = URL(string: game.thumbnail) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                    }
                }
            }
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        performSegue(withIdentifier: "showArcadeDetail", sender: selectedGame)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArcadeDetail", let gameDetailVC = segue.destination as? ArcadeDetailViewController, let selectedGame = sender as? Arcade {
            gameDetailVC.game = selectedGame
        }
    }
}
