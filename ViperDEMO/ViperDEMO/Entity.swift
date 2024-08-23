//
//  Entity.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import Foundation

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
}
