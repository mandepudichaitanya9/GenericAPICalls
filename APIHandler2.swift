//
//  APIHandler.swift
//  GenericAPICalls
//
//  Created by chaitanya on 08/09/22.
//

import Foundation
import Alamofire

// GET JSONModel

struct GetModel:Codable {
    var userId:Int
    var id:Int
    var title:String
    var body:String
}

// POST JSONModel

struct PostModel:Codable {
    var train_num:Int
    var name:String
    var train_from:String
    var train_to:String
    var data:TrainTime
}
struct TrainTime:Codable {
    var arriveTime:String
    var departTime:String
}

// POST URL:- https://trains.p.rapidapi.com/
// GET URL:- https://jsonplaceholder.typicode.com/posts/


// MARK: - Declaring Enum

enum ItemType {
    case callingPostAPI
    case callingGetAPI
}

// MARK: - Protocol Declaration Inside Varibles

protocol ItemName {
    var url:String {get}
    var headers:HTTPHeaders {get}
    var httpMethod:HTTPMethod {get}
    var encoding:ParameterEncoding {get}
}


// MARK: - Existing Enum Type Extension


extension ItemType:ItemName {
    var url: String {
        switch self {
        case .callingGetAPI:
            return "https://jsonplaceholder.typicode.com/posts/"
        case .callingPostAPI:
            return "https://trains.p.rapidapi.com/"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .callingGetAPI:
            return ["content-type": "application/json"]
        case .callingPostAPI:
            return [
                "content-type": "application/json",
                "X-RapidAPI-Key": "00ab76053cmshfb85d0da8ddbadcp1bb580jsn5e5e619aa0e0",
                "X-RapidAPI-Host": "trains.p.rapidapi.com"
            ]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .callingGetAPI:
            return .get
        case .callingPostAPI:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    
}



class APIHandler {
    
    // MARK: - Generic Method Declaration T 
    
    func genericAPICalling<T:Codable>(type:ItemType, parameters:[String:Any]? = nil, handler: @escaping (_ result:[T]) -> (Void)){
        AF.request(type.url, method: type.httpMethod, parameters: parameters, encoding: type.encoding, headers: type.headers).response { responce in
            switch responce.result {
            case .success(_):
                if let data = responce.data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(json ?? "")
                    if let decode = try? JSONDecoder().decode([T].self, from: data) {
                    handler(decode)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
       
    }
    
    
}
