//
//  BaseProvider.swift
//  AppStore
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import Reachability

/// Image service
protocol BaseServiceProtocol {
    func getValues(startIndex: Int, completion: @escaping ((() throws -> (MainList)) -> Void))
}

protocol DetailServiceProtocol {
    func getDetailValues (urlID: URL, completion: @escaping ((() throws -> (ItemDetail)) -> Void))
}

protocol PostFavoriteProtocol {
    func post(postString: String, completion: @escaping ((() throws -> (String)) -> Void))
}

class BaseProvider: BaseServiceProtocol {
    private let session: BaseURLSession
    private let reachability: BaseReachability
    
    init(session: URLSession = URLSession.shared, reachability: BaseReachability = Reachability(hostName: Constants.WEBSERVICE_BASE_URL)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getValues(startIndex: Int, completion: @escaping ((() throws -> (MainList)) -> Void)) {
        
        guard reachability.internetIsReachable else {
            completion { throw BaseError.offlineMode }
            return
        }
        
        guard let baseURL = completeUrl(startIndex: startIndex) else {
            completion { throw BaseError.generic }
            return
        }
        
        session.loadData(from:baseURL) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let values = try JSONDecoder().decode(MainList.self, from: data)
                    
                    let valueList = MainList(results: values.results)
                    
                    completion { valueList }
                } catch {
                    completion { throw BaseError.parse(String(describing: Result.self)) }
                }
            }
        }
    }
}


extension BaseProvider : DetailServiceProtocol {
    func getDetailValues (urlID: URL, completion: @escaping ((() throws -> (ItemDetail)) -> Void)) {
        
        guard reachability.internetIsReachable else {
            completion { throw BaseError.offlineMode }
            return
        }
        
        session.loadData(from:urlID) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let values = try JSONDecoder().decode(ItemDetail.self, from: data)
                
                    let valueList = ItemDetail(abilities: values.abilities, gameIndices: values.gameIndices, height: values.height, name: values.name, order: values.order, sprites: values.sprites, stats: values.stats, types: values.types, weight: values.weight)
                    
                    completion { valueList }
                } catch {
                    completion { throw BaseError.parse(String(describing: Result.self)) }
                }
            }
        }
    }
}

extension BaseProvider: PostFavoriteProtocol {
    func post(postString: String, completion: @escaping ((() throws -> (String)) -> Void)) {
        let url = URL(string: Constants.WEBHOOK_URL_POST)
        
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = Constants.POST
                 
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        session.postFavorite(from: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if data != nil {
                completion { Constants.SUCCESS }
            }
        }
    }
}

private extension BaseProvider {
    func completeUrl(startIndex: Int) -> URL? {
        var urlComponents = URLComponents(string: Constants.WEBSERVICE_BASE_URL)
        urlComponents?.queryItems = [URLQueryItem(name: Constants.LIMIT, value: Constants.VALUELIMIT),
                  URLQueryItem(name: Constants.OFFSET, value: Constants.VALUEOFFSET)]
        return urlComponents?.url
    }
}
