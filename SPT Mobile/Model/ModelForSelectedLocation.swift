//
//  ModelForSelectedLocation.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 22.09.2024.
//

import Foundation

// MARK: - ModelForSelectedLocation
struct ModelForSelectedLocation: Codable {
    let count, minDuration, maxDuration: Int
    let maxtime: Int
    let connections: [Connections]
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case count
        case minDuration = "min_duration"
        case maxDuration = "max_duration"
        case maxtime, connections, description
    }
}

// MARK: - Connection
struct Connections: Codable {
    let from, departure, to, arrival: String
    let duration: Int
    let occupancy: String?
    let legs: [Legs]

    enum CodingKeys: String, CodingKey {
        case from, departure, to, arrival, duration
        case occupancy, legs
    }
}

// MARK: - Leg
struct Legs: Codable {
    let departure: String?
    let name: String
    let type: TypeNames?
    let terminal: String?
    let runningtime: Int?
    let exit: Exits?
    let arrival, tripid, stopid: String?
    let x, y: Xs?  // Use Xs enum here
    let sbbName, line: String?
    let waittime: Int?
    let g: String?
    let l, z: String?
    let legOperator: String?
    let stops: [Stops]?
    let contopStop: JSONNulls?
    let occupancy: String?
    let disruptions: JSONAnys?
    let lon, lat: Double?
    let normalTime: Int?
    let track: String?

    enum CodingKeys: String, CodingKey {
        case departure, name, type, terminal, runningtime, exit
        case arrival, tripid, stopid, x, y
        case sbbName = "sbb_name"
        case line, waittime
        case g = "*G"
        case l = "*L"
        case z = "*Z"
        case legOperator = "operator"
        case stops
        case contopStop = "contop_stop"
        case occupancy, disruptions, lon, lat
        case normalTime = "normal_time"
        case track
    }
}

// MARK: - Exit
struct Exits: Codable {
    let arrival, stopid: String
    let x, y: Xs?  // Use Xs enum here
    let name: String
    let sbbName: String?
    let waittime: Int?
    let lon, lat: Double
    let track: String?

    enum CodingKeys: String, CodingKey {
        case arrival, stopid, x, y, name
        case sbbName = "sbb_name"
        case waittime, lon, lat, track
    }
}

// MARK: - Stop
struct Stops: Codable {
    let arrival, departure: String?
    let name, stopid: String
    let x, y: Int
    let lon, lat: Double
    let occupancy: String?
}

enum TypeNames: String, Codable {
    case bus = "bus"
    case expressTrain = "express_train"
    case strain = "strain"
    case railway = "railway"
    case walk = "walk"
    case tram = "tram"
    
    case unknown = "unknown"
       
       init(from decoder: Decoder) throws {
           let container = try decoder.singleValueContainer()
           let value = try container.decode(String.self)
           self = TypeNames(rawValue: value) ?? .unknown
       }
}

// MARK: - Point
struct Points: Codable {
    let text: String
    let url: String
    let x, y: Xs
    let lon, lat: Double
    let id: String?
}

enum Xs: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Xs.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for X"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Encode/decode helpers

class JSONNulls: Codable, Hashable {

    public static func == (lhs: JSONNulls, rhs: JSONNulls) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNulls.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKeys: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAnys: Codable {
    let value: Any

    // Error handling methods for decoding and encoding errors
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAnys.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    // Decode from a single value container
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNulls()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    // Decode from an unkeyed container (array)
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let isNil = try? container.decodeNil(), isNil {
            return JSONNulls()
        }
        if var arrayContainer = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &arrayContainer)
        }
        if var dictContainer = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &dictContainer)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    // Decode from a keyed container (dictionary)
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let isNil = try? container.decodeNil(forKey: key), isNil {
            return JSONNulls()
        }
        if var arrayContainer = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &arrayContainer)
        }
        if var dictContainer = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &dictContainer)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    // Decode an array from an unkeyed container
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var array: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            array.append(value)
        }
        return array
    }

    // Decode a dictionary from a keyed container
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    // Encode an array into an unkeyed container
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNulls {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var nestedContainer = container.nestedUnkeyedContainer()
                try encode(to: &nestedContainer, array: value)
            } else if let value = value as? [String: Any] {
                var nestedContainer = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &nestedContainer, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    // Encode a dictionary into a keyed container
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNulls {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var nestedContainer = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &nestedContainer, array: value)
            } else if let value = value as? [String: Any] {
                var nestedContainer = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &nestedContainer, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    // Encode a single value
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNulls {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    // Initialize from a decoder
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAnys.decodeArray(from: &arrayContainer)
        } else if var dictContainer = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAnys.decodeDictionary(from: &dictContainer)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAnys.decode(from: container)
        }
    }

    // Encode to an encoder
    public func encode(to encoder: Encoder) throws {
        if let array = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAnys.encode(to: &container, array: array)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAnys.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAnys.encode(to: &container, value: self.value)
        }
    }
}
