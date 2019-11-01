//
//  UserDetails.swift
//  AlamoFire+Api
//
//  Created by Tushar on 20/09/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit

class UserDetails: Decodable {

    let page: Int?
    let perPage: Int?
    let total: Int?
    let totalPages: Int?
    let data: [dataResponse]?
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case total = "total"
        case totalPages = "total_pages"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        data = try values.decodeIfPresent([dataResponse].self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(page, forKey: .page)
        try container.encodeIfPresent(perPage, forKey: .perPage)
        try container.encodeIfPresent(total, forKey: .total)
        try container.encodeIfPresent(totalPages, forKey: .totalPages)
        try container.encodeIfPresent(data, forKey: .data)
    }
}

class dataResponse: Codable {
    
    let id: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(avatar, forKey: .avatar)
    }
    
}
