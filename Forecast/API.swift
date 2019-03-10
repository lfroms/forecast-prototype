//  This file was automatically generated and should not be edited.

import Apollo

/// A two or three character province code.
public enum Region: RawRepresentable, Equatable, Hashable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case ab
  case bc
  case hef
  case mb
  case nb
  case nl
  case ns
  case nt
  case nu
  case on
  case pe
  case qc
  case sk
  case yt
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AB": self = .ab
      case "BC": self = .bc
      case "HEF": self = .hef
      case "MB": self = .mb
      case "NB": self = .nb
      case "NL": self = .nl
      case "NS": self = .ns
      case "NT": self = .nt
      case "NU": self = .nu
      case "ON": self = .on
      case "PE": self = .pe
      case "QC": self = .qc
      case "SK": self = .sk
      case "YT": self = .yt
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .ab: return "AB"
      case .bc: return "BC"
      case .hef: return "HEF"
      case .mb: return "MB"
      case .nb: return "NB"
      case .nl: return "NL"
      case .ns: return "NS"
      case .nt: return "NT"
      case .nu: return "NU"
      case .on: return "ON"
      case .pe: return "PE"
      case .qc: return "QC"
      case .sk: return "SK"
      case .yt: return "YT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Region, rhs: Region) -> Bool {
    switch (lhs, rhs) {
      case (.ab, .ab): return true
      case (.bc, .bc): return true
      case (.hef, .hef): return true
      case (.mb, .mb): return true
      case (.nb, .nb): return true
      case (.nl, .nl): return true
      case (.ns, .ns): return true
      case (.nt, .nt): return true
      case (.nu, .nu): return true
      case (.on, .on): return true
      case (.pe, .pe): return true
      case (.qc, .qc): return true
      case (.sk, .sk): return true
      case (.yt, .yt): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class WeatherQuery: GraphQLQuery {
  public let operationDefinition =
    "query Weather($region: Region!, $code: Int!) {\n  weather(region: $region, code: $code) {\n    __typename\n    license\n  }\n}"

  public var region: Region
  public var code: Int

  public init(region: Region, code: Int) {
    self.region = region
    self.code = code
  }

  public var variables: GraphQLMap? {
    return ["region": region, "code": code]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("weather", arguments: ["region": GraphQLVariable("region"), "code": GraphQLVariable("code")], type: .object(Weather.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(weather: Weather? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "weather": weather.flatMap { (value: Weather) -> ResultMap in value.resultMap }])
    }

    /// Get weather information for a given station.
    public var weather: Weather? {
      get {
        return (resultMap["weather"] as? ResultMap).flatMap { Weather(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "weather")
      }
    }

    public struct Weather: GraphQLSelectionSet {
      public static let possibleTypes = ["SiteData"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("license", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(license: String) {
        self.init(unsafeResultMap: ["__typename": "SiteData", "license": license])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var license: String {
        get {
          return resultMap["license"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "license")
        }
      }
    }
  }
}