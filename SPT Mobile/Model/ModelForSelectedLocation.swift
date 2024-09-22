//
//  ModelForSelectedLocation.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 22.09.2024.
//

import Foundation

// MARK: - ModelForSelectedLocation
struct ModelForSelectedLocation: Codable {
    let eof: Int
    let url: String
    let count: Int
    let points: [Points]
    let maxtime, rawtime: Int
    let request: JSONNulls?
    let connections: [Connections]
    let description: String
    let maxDuration, minDuration: Int

    enum CodingKeys: String, CodingKey {
        case eof, url, count, points, maxtime, rawtime, request, connections, description
        case maxDuration = "max_duration"
        case minDuration = "min_duration"
    }
}

// MARK: - Connection
struct Connections: Codable {
    let to, from: String
    let legs: [Legs]
    let arrival: String
    let isMain: Bool
    let duration: Int
    let departure: String
    let disruptions: DisruptionsClass?

    enum CodingKeys: String, CodingKey {
        case to, from, legs, arrival
        case isMain = "is_main"
        case duration, departure, disruptions
    }
}

// MARK: - DisruptionsClass
struct DisruptionsClass: Codable {
    let ch1Sstid100001Af692Cf8Ef834700AeadA5736Bcf1Ce91: Ch1Sstid100001Af692Cf8Ef834700AeadA5736Bcf1Ce91

    enum CodingKeys: String, CodingKey {
        case ch1Sstid100001Af692Cf8Ef834700AeadA5736Bcf1Ce91 = "ch:1:sstid:100001:af692cf8-ef83-4700-aead-a5736bcf1ce9_1"
    }
}

// MARK: - Ch1Sstid100001Af692Cf8Ef834700AeadA5736Bcf1Ce91
struct Ch1Sstid100001Af692Cf8Ef834700AeadA5736Bcf1Ce91: Codable {
    let id, type: String
    let texts: Texts
    let periods: Periods
    let priority, progress, alertCause: String
    let perspective: [String]

    enum CodingKeys: String, CodingKey {
        case id, type, texts, periods
        case priority = "Priority"
        case progress = "Progress"
        case alertCause = "AlertCause"
        case perspective
    }
}

// MARK: - Periods
struct Periods: Codable {
    let validity, publication: [[Int]]
}

// MARK: - Texts
struct Texts: Codable {
    let l, m, s: L

    enum CodingKeys: String, CodingKey {
        case l = "L"
        case m = "M"
        case s = "S"
    }
}

// MARK: - L
struct L: Codable {
    let reason, summary, duration, consequence: String
    let recommendation: String
}

// MARK: - Leg
struct Legs: Codable {
    let exit: Exits?
    let name: String
    let type: TypeEnum?
    let terminal, departure: String?
    let isaddress: Bool?
    let typeName: TypeName?
    let runningtime, x, y: Int?
    let g: G?
    let l, z: String?
    let lat, lon: Double?
    let line: String?
    let stops: [Stops]?
    let style, stopid, tripid, arrival: String?
    let bgcolor: Bgcolor?
    let fgcolor: Fgcolor?
    let legOperator: Operator?
    let sbbName: String?
    let waittime: Int?
    let occupancy: JSONNulls?
    let attributes: Attributess?
    let contopStop: JSONNulls?
    let disruptions: DisruptionsUnion?
    let normalTime: Int?
    let track: String?

    enum CodingKeys: String, CodingKey {
        case exit, name, type, terminal, departure, isaddress
        case typeName = "type_name"
        case runningtime, x, y
        case g = "*G"
        case l = "*L"
        case z = "*Z"
        case lat, lon, line, stops, style, stopid, tripid, arrival, bgcolor, fgcolor
        case legOperator = "operator"
        case sbbName = "sbb_name"
        case waittime, occupancy, attributes
        case contopStop = "contop_stop"
        case disruptions
        case normalTime = "normal_time"
        case track
    }
}

// MARK: - Attributes
struct Attributess: Codable {
    let the1_0_Nf, the0_48_Rz, the1_46_Fa, the1_47_Bz: String?
    let the1_47_FS, the0_14_Wr: String?

    enum CodingKeys: String, CodingKey {
        case the1_0_Nf = "1_0_NF"
        case the0_48_Rz = "0_4.8_RZ"
        case the1_46_Fa = "1_4.6_FA"
        case the1_47_Bz = "1_4.7_BZ"
        case the1_47_FS = "1_4.7_FS"
        case the0_14_Wr = "0_1.4_WR"
    }
}

enum Bgcolor: String, Codable {
    case f00 = "f00"
    case ffffff = "ffffff"
    case the039 = "039"
}

enum DisruptionsUnion: Codable {
    case anythingArray([JSONAnys])
    case disruptionsClass(DisruptionsClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([JSONAnys].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode(DisruptionsClass.self) {
            self = .disruptionsClass(x)
            return
        }
        throw DecodingError.typeMismatch(DisruptionsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DisruptionsUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anythingArray(let x):
            try container.encode(x)
        case .disruptionsClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Exit
struct Exits: Codable {
    let x, y: Int
    let lat, lon: Double
    let name, stopid, arrival, sbbName: String
    let waittime: Int?
    let track: String?

    enum CodingKeys: String, CodingKey {
        case x, y, lat, lon, name, stopid, arrival
        case sbbName = "sbb_name"
        case waittime, track
    }
}

enum Fgcolor: String, Codable {
    case fff = "fff"
    case the000 = "000"
}

enum G: String, Codable {
    case b = "B"
    case ic = "IC"
    case s = "S"
}

enum Operator: String, Codable {
    case sbb = "SBB"
    case vzo = "VZO"
}

// MARK: - Stop
struct Stops: Codable {
    let x, y: Int
    let lat, lon: Double
    let name, stopid: String
    let arrival, departure: String?
}

enum TypeEnum: String, Codable {
    case bus = "bus"
    case expressTrain = "express_train"
    case strain = "strain"
    case walk = "walk"
}

enum TypeName: String, Codable {
    case bus = "Bus"
    case railway = "Railway"
    case sTrain = "S-Train"
    case walk = "Walk"
}

// MARK: - Point
struct Points: Codable {
    let x, y: Xs
    let lat, lon: Double
    let url: String
    let text: String
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

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAnys.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

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
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNulls()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

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
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNulls()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

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
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

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
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

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

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAnys.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAnys.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAnys.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAnys.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAnys.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAnys.encode(to: &container, value: self.value)
            }
    }
}
