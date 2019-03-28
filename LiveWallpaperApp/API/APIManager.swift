import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let shared = APIManager()
    private init(){}
    
    let baseUrl = "https://wallpapers.mediacube.games/"
    typealias Completion = (Bool, JSON, String) -> ()
    
    // MARK: - LivePhotos
    
    func getLivePhotoWith(url: URL, completion: @escaping Completion) {        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
    }
    
    func getLivePhotoBy(id: String, completion: @escaping Completion) {
        let url = baseUrl + "api/photos/\(id)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
    }
    
    func getLivePhotos(completion: @escaping Completion) {
        let url = baseUrl + "api/photos"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
            self.responseHandler(response: response, completion: completion)
        }
    }
    
    // MARK: - response
    
    private func responseHandler(response: DefaultDataResponse, completion: @escaping Completion) {
        let status = response.response?.statusCode
        let data = response.data
        if let status = status {
            if status == 200 || status == 204 {
                if let data = data {
                    let json = JSON(data: data)
                    print("responseHandler ", json)
                    completion(true, json, "")
                } else {
                    completion(true, [], "")
                }
            } else if status >= 500 {
                completion(false, "", "Сервер не работает \(status)")
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    print("responseHandler error, ", json)
                    if let message = json["message"].string {
                        completion(false, json, message)
                    } else {
                        completion(false, json, "Unknown error")
                    }
                }
                completion(false, [], "Unknown error")
            }
        }
    }
}
