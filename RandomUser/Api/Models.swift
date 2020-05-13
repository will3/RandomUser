// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct RUWelcome: Codable {
    let results: [RUUser]
    let info: RUInfo
}

// MARK: - Info
struct RUInfo: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - User
struct RUUser: Codable {
    let gender: String
    let name: RUName
    let location: RULocation
    let email: String
    let login: RULogin
    let dob, registered: RUDob
    let phone, cell: String
    let id: RUID
    let picture: RUPicture
    let nat: String
}

// MARK: - Dob
struct RUDob: Codable {
    let date: String
    let age: Int
}

// MARK: - ID
struct RUID: Codable {
    let name, value: String?
}

// MARK: - Location
struct RULocation: Codable {
    let street: RUStreet
    let city, state, country: String
    let postcode: StringOrInt
    let coordinates: RUCoordinates
    let timezone: RUTimezone
}

// MARK: - Coordinates
struct RUCoordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
struct RUStreet: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
struct RUTimezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}

// MARK: - Login
struct RULogin: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct RUName: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct RUPicture: Codable {
    let large, medium, thumbnail: String
}

enum StringOrInt: Codable {
  case int(Int)
  case string(String)

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = try .int(container.decode(Int.self))
    } catch DecodingError.typeMismatch {
      do {
        self = try .string(container.decode(String.self))
      } catch DecodingError.typeMismatch {
        throw DecodingError.typeMismatch(StringOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .int(let int):
      try container.encode(int)
    case .string(let string):
      try container.encode(string)
    }
  }
}
