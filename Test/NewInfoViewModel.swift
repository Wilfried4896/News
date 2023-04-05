
import Foundation
import Combine

enum NetworkError: Error {
    case invalidUrl
    case badServerResponse
    case unknown
}

final class NewViewModel {
    
    enum StateNewViewModel {
        case loading
        case success(articles: [Articles])
        case failed(error: Error)
        case none
    }
    
    let newService = NewService()
    var cancelled = Set<AnyCancellable>()
    @Published var state: StateNewViewModel = .none
    
    var textSearch: String
    
    init(textSearch: String) {
        self.textSearch = textSearch
        
        receivedNewFromServer()
        
    }
    
    private func receivedNewFromServer() {
        state = .loading
        
        newService.getNewFromServer(urlString: "https://newsapi.org/v2/everything?q=\(textSearch)&apiKey=55c8624285d94dcf975066f96611753a", type: Article.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.state = .failed(error: error)
                default:
                    break
                }
            } receiveValue: { article in
                self.state = .success(articles: article.articles)
            }
            .store(in: &cancelled)
        
    }
}

