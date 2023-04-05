struct Article: Codable {
    var articles: [Articles]
}

struct Articles: Codable {
    var source: Source
    var author: String?
    var title: String?
    var content: String?
    var description: String?
    var urlToImage: String?
    var url: String?
    var publishedAt: String?
}


struct Source: Codable {
    var name: String?
}
