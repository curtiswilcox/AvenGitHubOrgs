//
//  Organization.swift
//  Shared
//
//  Created by Curtis Wilcox on 1/27/22.
//

import Foundation

struct Organization: Decodable, Hashable, Identifiable {
    var id: URL {
        githubURL
    }
    
    let name: String
    let description: String?
    var githubURL: URL {
        URL(string: "https://github.com/\(name)")!
    }
    let avatarURL: URL
    
    var isSelected = false
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        
        self.description = {
            let desc = try? values.decode(String.self, forKey: .description)
            return (desc?.isEmpty ?? true) ? nil : desc
        }()
                
        try self.avatarURL = {
            let url = try values.decode(String.self, forKey: .avatarURL)
            return URL(string: url)!
        }()
    }
    
    /// Overload `==` operator.
    ///
    /// Compare two `Organization`s based on their IDs.
    static func ==(lhs: Organization, rhs: Organization) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Organization {
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case description = "description"
        case avatarURL = "avatar_url"
    }
}
