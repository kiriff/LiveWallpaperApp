import Foundation
import ObjectMapper

struct LWLinks: Mappable {
    var first: String?
    var last: String?
    var prev: String?
    var next: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        first   <- map["first"]
        last   <- map["last"]
        prev   <- map["prev"]
        next   <- map["next"]
    }
}
