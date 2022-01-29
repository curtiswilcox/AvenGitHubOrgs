//
//  OrganizationObserver.swift
//  AvenGitHubOrgs
//
//  Created by Curtis Wilcox on 1/27/22.
//

import Foundation

class OrganizationObserver: ObservableObject {
    @Published var organizations: [Organization]
    
    init() {
        self.organizations = []
    }
    
    func retrieveOrganizations() async throws {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.github.com/organizations")!)
        
        let orgs = try JSONDecoder().decode([Organization].self, from: data)
        
        DispatchQueue.main.async {  // can't publish UI changes from background thread (`self.organizations` is a published property)
            self.organizations = orgs
        }
    }
}
