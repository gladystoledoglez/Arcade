//
//  Profile.swift
//  FinalProject

import Foundation

struct Profile {
    let name: String
    let email: String
    let phoneNumber: String
    let dateOfBirth: Date?
    
    init(name: String, email: String, phoneNumber: String, dateOfBirth: Date){
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
    }
}
