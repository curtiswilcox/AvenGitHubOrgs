# AvenGitHubOrgs

## Overview
Using GitHub's public REST API, display a list of organizations. Must include the following:
- Image
- Name
- Description
- GitHub URL

## Requirements
- iOS 15.0+
- SwiftUI 3.0+
- Xcode 13+

## Decisions
- The GitHub link is string-interpolated and will take the user to the organization's page on GitHub, not to the url provided in the REST API (that link would display more information about the organization).
- The link opens a window in an external web browser.

