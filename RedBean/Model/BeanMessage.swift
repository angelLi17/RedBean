//
//  BeanMessage.swift
//  RedBean
//

import Foundation
import StreamVideo

/// Small messages friends send each other through the call (Stream custom events).
enum BeanMessage: Codable, Equatable {
    case timer(SharedTimer)
    case checklistProgress(done: Int, total: Int)
    /// Someone tapped End Bean: both friends go to the photobooth.
    case photoboothOpen
    /// Someone tapped start in the photobooth: both phones count down from the same moment.
    case photoboothStart(at: Date)

    private static let key = "redbean"

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    /// Wraps the message as one JSON string, so it survives Stream's custom-event format unchanged.
    var customEventData: [String: RawJSON] {
        guard let data = try? Self.encoder.encode(self), let json = String(data: data, encoding: .utf8) else {
            return [:]
        }
        return [Self.key: .string(json)]
    }

    init?(customEventData: [String: RawJSON]) {
        guard
            case let .string(json)? = customEventData[Self.key],
            let message = try? Self.decoder.decode(BeanMessage.self, from: Data(json.utf8))
        else { return nil }
        self = message
    }
}
