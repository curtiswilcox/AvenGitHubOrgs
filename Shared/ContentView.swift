//
//  ContentView.swift
//  Shared
//
//  Created by Curtis Wilcox on 1/27/22.
//

import SwiftUI


/// Initial View for application.
///
/// Displays a list of organizations using GitHub's public REST API.
struct ContentView: View {
    @StateObject var observer = OrganizationObserver()
    @State var isLoadingInitialView = true
    @State var searchText = ""
        
    var body: some View {
        ZStack {
            NavigationView {
                let validOrgs = $observer.organizations.filter { $org in
                    searchText.isEmpty ||
                    org.name.lowercased().contains(searchText.lowercased())
                }
                List(validOrgs) { $org in
                    OrganizationRow(organization: $org)
                }
                .refreshable {  // pull-to-refresh functionality
                    do {
                        try await observer.retrieveOrganizations()
                    } catch {
                        // do nothing
                    }
                }
                .searchable(text: $searchText)  // search bar at top of list
                .navigationTitle("Organizations")
            }
            
            if self.isLoadingInitialView {
                ProgressView()
                    .scaleEffect(x: 1.5, y: 1.5)
            }
        }
        .task {
            self.isLoadingInitialView = true
            do {
                try await observer.retrieveOrganizations()
            } catch {
                // do nothing
            }
            self.isLoadingInitialView = false
        }
    }
    
    /// Display row for each `Organization`.
    private struct OrganizationRow: View {
        @Environment(\.openURL) var openURL
        @Binding var organization: Organization
        
        var body: some View {
//            Button {  // use this for the cell to flash gray when tapped (as well as display a checkmark) (as opposed to `onTapGesture`)
//                withAnimation {
//                    organization.isSelected.toggle()
//                }
//            } label: {
            HStack(alignment: .top) {
                VStack {
                    Spacer()
                    AvatarImage(url: organization.avatarURL)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(organization.name)
                            .font(.headline)
                            .padding(.bottom, 2)
                        if organization.isSelected {
                            Spacer()
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle)
                                .padding(.trailing)
                        }
                    }
                                                
                    if let description = organization.description {
                        Text(description)
                            .font(.system(size: 14))
                    } else {
                        Text("No description available")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Link(organization.githubURL.absoluteString, destination: organization.githubURL)
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                        .onTapGesture {
                            openURL(organization.githubURL)
                        }
                }
                .padding(.vertical)
            }
            .onTapGesture {  // use this for cell to not flash gray when displaying checkmark (as opposed to the `Button`)
                withAnimation {
                    organization.isSelected.toggle()
                }
            }
//            }  // end of `Button`
        }
    }
    
    /// Display image for the GitHub avatar, or an indeterminate `ProgressView` if the
    /// image has not yet loaded.
    private struct AvatarImage: View {
        let url: URL
        
        var body: some View {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .background(.white)
                } else { // placeholder or error
                    ProgressView()
                        .scaleEffect(x: 1.5, y: 1.5)
                        .background(.clear)
                }
            }
            .frame(width: 100, height: 100)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(.primary, lineWidth: 2))
            .cornerRadius(15)
            .padding(.vertical, 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
