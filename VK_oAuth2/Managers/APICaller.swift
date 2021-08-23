//
//  APICaller.swift
//  HedgTest
//
//  Created by iMac on 16.07.2021.
//

import Foundation


final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let owner_id = "-65251721"
        static let album_id = "186486245"
        static let basicURL = "https://api.vk.com/method/"
        static let albumPhotosURL = "photos.get?&owner_id=\(owner_id)&album_id=\(album_id)"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    

    public func getAlbumPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        guard let url = URL(string: Constants.basicURL + Constants.albumPhotosURL + "&access_token=\(AuthManager.shared.accessToken ?? "")&v=5.131&count=20") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.timeoutInterval = 30

        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }


            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)
                let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
                
                let photos: [Photo] = albumResponse.response.items.compactMap { (photoModel) -> Photo? in
                    
                    return Photo(date: photoModel.date, id: photoModel.id, urlString: photoModel.sizes.filter{$0.type == "x"}.first?.url ?? "")
                }
                completion(.success(photos))
            }
            catch {
                completion(.failure(error))
            }

        }

        task.resume()
    }
    
}
