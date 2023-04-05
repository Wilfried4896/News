
import Foundation
import Combine

class NewService {

    var cancelled = Set<AnyCancellable>()
    
    func getNewFromServer<T: Codable> (urlString: String, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self else { return }
            
            guard let url = URL(string: urlString) else {
                promise(.failure(NetworkError.invalidUrl))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw NetworkError.badServerResponse
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    default:
                        break
                    }
                } receiveValue: { resultData in
                    promise(.success(resultData))
                }
                .store(in: &self.cancelled)
        }
    }
    
    func getImageFromServer(urlImage: String) -> Future<Data, Error> {
        return Future<Data, Error> { [weak self] promise in
            guard let self else { return }
            
            guard let url = URL(string: urlImage) else {
                promise(.failure(NetworkError.invalidUrl))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw NetworkError.badServerResponse
                    }
                    return data
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    default:
                        break
                    }
                } receiveValue: { resultData in
                    promise(.success(resultData))
                }
                .store(in: &self.cancelled)
        }
    }
}
