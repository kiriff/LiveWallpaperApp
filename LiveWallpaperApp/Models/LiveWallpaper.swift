import Foundation
import ObjectMapper

struct LiveWallpaper: Mappable {
    var id: String!
    var imagePath: String?
    var moviePath: String?
    var created: String?
    var updated: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        imagePath   <- map["image_path"]
        moviePath   <- map["movie_path"]
        created     <- map["created_at"]
        updated     <- map["updated_at"]
    }
}
