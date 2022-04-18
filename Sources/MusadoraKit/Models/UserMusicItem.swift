//
//  UserMusicItem.swift
//  UserMusicItem
//
//  Created by Rudrank Riyam on 02/04/22.
//

import MusicKit

/// A collection of user music items.
public typealias UserMusicItems = MusicItemCollection<UserMusicItem>

/// A generic music item that may either contain an album, playlist or a station.
public enum UserMusicItem: Equatable, Hashable, Identifiable {
    case album(Album)
    case playlist(Playlist)
    case station(Station)
}

extension UserMusicItem: MusicItem {
    public var id: MusicItemID {
        let id: MusicItemID

        switch self {
            case .album(let album): id = album.id
            case .playlist(let playlist): id = playlist.id
            case .station(let station): id = station.id
        }

        return id
    }
}

extension UserMusicItem: Decodable {
    enum CodingKeys: CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(String.self, forKey: .type)
        switch type {
            case "albums", "library-albums":
                let album = try Album(from: decoder)
                self = .album(album)
            case "playlists", "library-playlists":
                let playlist = try Playlist(from: decoder)
                self = .playlist(playlist)
            case "stations":
                let station = try Station(from: decoder)
                self = .station(station)
            default:
                let decodingErrorContext = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unexpected type \"\(type)\" encountered for UserMusicItem."
                )
                throw DecodingError.typeMismatch(UserMusicItem.self, decodingErrorContext)
        }
    }
}

extension UserMusicItem: Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}
