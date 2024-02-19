//
//  Modals.swift
//  Concurrency
//
//  Created by Venkatesh Nyamagoudar on 5/5/23.
//

import Foundation

// MARK: Domains
public struct Domains: Decodable {
  public let data: [Domain]
}

// MARK: - Domain
public struct Domain: Decodable {
  public let attributes: Attributes
}

// MARK: - Attributes
public struct Attributes: Decodable {
  public let name: String
  public let description: String
  public let level: String
}

// MARK: Playlist
public class Playlist {
  // MARK: Properties
  public let title: String
  public let author: String
  public private(set) var songs: [String]

  // MARK: Initialization
  public init(title: String, author: String, songs: [String]) {
    self.title = title
    self.author = author
    self.songs = songs
  }

  // MARK: Methods
  public func add(song: String) {
    songs.append(song)
  }

  public func remove(song: String) {
    guard !songs.isEmpty, let index = songs.firstIndex(of: song) else {
      return
    }

    songs.remove(at: index)
  }

  public func move(song: String, from playlist: Playlist) {
    playlist.remove(song: song)
    add(song: song)
  }

  public func move(song: String, to playlist: Playlist) {
    playlist.add(song: song)
    remove(song: song)
  }
}
