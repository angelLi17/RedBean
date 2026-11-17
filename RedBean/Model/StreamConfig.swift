//
//  StreamConfig.swift
//  RedBean
//

import Foundation

enum StreamConfig {
    /// Your Stream app's API key from https://dashboard.getstream.io (the *key*, not the secret).
    /// It must belong to the same Stream app as the STREAM_API_SECRET used by the backend.
    /// The API key is public and safe to ship in the app; the secret must never be in the app.
    static let apiKey = "YOUR_STREAM_API_KEY"

    /// Region the getStreamToken Cloud Function is deployed to.
    static let functionsRegion = "us-central1"

    /// Stream's built-in call type that lets any signed-in user create and join calls.
    static let callType = "default"
}
