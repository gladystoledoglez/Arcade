//
//  ProfileViewController.swift
//  FinalProject

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    var userProfile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = "Gladys Toledo"
        let phoneNumber = "+55 92 9817-07176"
        let email = "gladysmtg1999@gmail.com"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateOfBirth = dateFormatter.date(from: "30/12/1999")
        
        userProfile = Profile(name: name, email: email, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth!)
        
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        signOutButton.layer.cornerRadius = 10
        signOutButton.layer.masksToBounds = true
        
        updateUI()
    }
    
    func updateUI() {
        if let profile = userProfile {
            profileImageView.image = UIImage(named: "profile_picture")
            nameLabel.text = profile.name
            phoneLabel.text = profile.phoneNumber
            emailLabel.text = profile.email
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let dateOfBirth = profile.dateOfBirth {
                dobLabel.text = dateFormatter.string(from: dateOfBirth)
            }
        }
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        exit(0)
    }
}
